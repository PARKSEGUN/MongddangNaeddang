package com.mongddangnaeddang.MNServer.game.service;

import com.mongddangnaeddang.MNServer.badge.dto.request.UserBadgeRequestDTO;
import com.mongddangnaeddang.MNServer.badge.dto.response.BadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.repository.UserBadgeRepository;
import com.mongddangnaeddang.MNServer.badge.service.BadgeService;
import com.mongddangnaeddang.MNServer.client.UTRClient;
import com.mongddangnaeddang.MNServer.game.dto.request.GameRequestDTO;
import com.mongddangnaeddang.MNServer.game.dto.request.TeamUserRequestDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.GameResponseDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.TeamUserResponseDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.UserMoveHistoryResponseDTO;
import com.mongddangnaeddang.MNServer.game.entity.MoveHistory;
import com.mongddangnaeddang.MNServer.game.repository.MoveHistoryRepository;
import com.mongddangnaeddang.MNServer.notification.dto.GroupNotification;
import com.mongddangnaeddang.MNServer.notification.service.FirebaseMessagingService;
import com.mongddangnaeddang.MNServer.redis.dto.PolygonDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.TeamRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.UserRequestDTO;
import com.mongddangnaeddang.MNServer.redis.service.RedisService;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.MultiPolygon;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.io.WKTWriter;
import org.locationtech.proj4j.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.IntStream;
import java.util.stream.Stream;

@Service
@Transactional
@RequiredArgsConstructor
public class GameServiceImpl implements GameService {
    private static final Logger logger = LoggerFactory.getLogger(GameServiceImpl.class);

    private final MoveHistoryRepository moveHistoryRepository;
    private final UserBadgeRepository userBadgeRepository;
    private final PolygonService polygonService;
    private final RedisService redisService;
    private final BadgeService badgeService;
    private final FirebaseMessagingService fms;
    private final UTRClient utrClient;
    private RedisTemplate<String, Object> redisTemplate;
    private ListOperations<String, Object> listOperations;

    @Autowired
    public void setRedisTemplate(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.listOperations = redisTemplate.opsForList();
    }

    @Override
    public GameResponseDTO finishGame(GameRequestDTO gameRequestDTO) {
        String authUuid = gameRequestDTO.getAuthUuid();

        // - 1. Polygon & 거리 계산
        Coordinate[] coordinates = polygonService.createConvexHull(gameRequestDTO.getMultipoints());
        Polygon polygon = polygonService.createPolygon(coordinates);
        double distance = calcDistance(transformCoordinates(gameRequestDTO.getMultipoints()));

        // - 2. DB에 raw Data 저장
        MoveHistory moveHistory = convertToEntity(gameRequestDTO, distance, polygon);
        moveHistoryRepository.save(moveHistory);

        // - 3. 겹치는 영역 확인
        List<PolygonDTO> intersectPolygons = redisService.getMap(polygon);

        // - 3-1. 빼앗긴 땅 재계산하여 업데이트
        String teamId = utrClient.getTeamId(authUuid);
        double deleteArea = 0D;
        Set<String> stolenTeamNames = new HashSet<>();
        Set<Integer> stolenTeamIds = new HashSet<>();
        for(PolygonDTO intersectPolygon : intersectPolygons){
            if(teamId.equals(intersectPolygon.getTeamId())){
                polygon = (Polygon) polygon.union(intersectPolygon.getPolygon());
                List<Polygon> intersectResult = geometryToPolygons(polygon.intersection(intersectPolygon.getPolygon()));
                deleteArea = calcAreaSum(intersectResult);
            } else {
                // - 면적 빼기
                List<Polygon> intersectResult = geometryToPolygons(intersectPolygon.getPolygon().intersection(polygon));
                double updateArea = calcAreaSum(intersectResult);
                TeamRequestDTO teamAreaRequestDTO = new TeamRequestDTO(intersectPolygon.getTeamId(), updateArea*-1, 0D, null);
                redisService.updateTeam(teamAreaRequestDTO);

                // - 폴리곤 재계산
                List<Polygon> differenceResult = geometryToPolygons(intersectPolygon.getPolygon().difference(polygon));
                for(Polygon differencePolygon : differenceResult){
                    String polygonWKT = new WKTWriter().write(differencePolygon);
                    if(polygonWKT.equals("POLYGON EMPTY")) polygonWKT = null;
                    TeamRequestDTO teamRequestDTO = new TeamRequestDTO(intersectPolygon.getTeamId(), 0D, 0D, polygonWKT);
                    redisService.updateTeam(teamRequestDTO);
                }

                stolenTeamIds.add(Integer.parseInt(intersectPolygon.getTeamId()));
                stolenTeamNames.add(utrClient.getTeamName(Integer.parseInt(intersectPolygon.getTeamId())));
            }
            redisService.deleteTeamPolygon(intersectPolygon.getTeamId(), intersectPolygon.getPolygon());
        }

        // - 3-2. 뺏긴 팀에게 알림보내기
        String sendTeamName = utrClient.getTeamName(Integer.parseInt(teamId)); // 뺏은 팀
        for(int teamNum : stolenTeamIds){
            ResponseEntity<List<TeamUserResponseDTO>> teamUsers= utrClient.getTeamMembers(teamNum);
            for(TeamUserResponseDTO teamUser : teamUsers.getBody()){
                GroupNotification groupNotification = new GroupNotification("긴급! 땅 탈취!", sendTeamName+"팀이 우리 팀 땅을 빼앗았습니다.", teamUser.getAuthUuid(), teamUser.getNickname(), teamUser.getFcmToken());
                fms.sendRootAlarm(groupNotification);
            }
        }

        // - 4. redis 업데이트
        double area = calcArea(polygon);
        TeamRequestDTO teamRequestDTO = new TeamRequestDTO(teamId, area-deleteArea, distance, new WKTWriter().write(polygon));
        redisService.updateTeam(teamRequestDTO);

        UserRequestDTO userRequestDTO = new UserRequestDTO(authUuid, distance);
        redisService.updateUser(userRequestDTO);

        // - 5. 뱃지 획득 여부 판단
        double userDistance = Double.parseDouble(redisService.getUser(authUuid).getDistanceSum());
        List<BadgeResponseDTO> badges = badgeService.getAllBadges();
        for(BadgeResponseDTO badge : badges){
            if(badge.getCondition() <= userDistance){
                if(!userBadgeRepository.existsByIdAndAuthUuid(badge.getId(), authUuid)){
                    UserBadgeRequestDTO userBadgeRequestDTO = new UserBadgeRequestDTO(authUuid, badge.getId());
                    badgeService.createUserBadge(userBadgeRequestDTO);
                    // - 5-1. 획득했을 경우 획득 알람
                    fms.sendBadgeAlarm(authUuid, badge.getName());
                }
            }
        }
        return convertToDTO(moveHistory, area-deleteArea, stolenTeamNames);
    }

    @Override
    public List<UserMoveHistoryResponseDTO> getUserMoveHistory(String authUuid) {
        List<MoveHistory> moveHistories = moveHistoryRepository.findAllByAuthUuid(authUuid);
        List<UserMoveHistoryResponseDTO> userMoveHistoryResponseDTOS = new ArrayList<>();
        for(MoveHistory mh : moveHistories) {
            userMoveHistoryResponseDTOS.add(convertToUserMoveHistoryDTO(mh));
        }
        return userMoveHistoryResponseDTOS;
    }

    @Override
    public double getTeamMoveSum(String authUuid, LocalDateTime joinAt) {
        // 특정 유저가 특정팀에 합류한 이후, 총 뛴거리 리턴
        return moveHistoryRepository.findTotalDistanceByAuthUuidAndSince(authUuid,joinAt);
    }

    // - 좌표계 변환
    public Coordinate[] transformCoordinates(List<List<Double>> multipoints){
        int size = multipoints.size();
        Coordinate[] coordinates = new Coordinate[size];
        for(int i=0; i<size; i++){
            double placeX = multipoints.get(i).get(0);
            double placeY = multipoints.get(i).get(1);
            ProjCoordinate srcCoord = new ProjCoordinate(placeY, placeX);
            ProjCoordinate dstCoord = new ProjCoordinate();
            CRSFactory crsFactory = new CRSFactory();
            CoordinateReferenceSystem srcCrs = crsFactory.createFromName("EPSG:4326");
            CoordinateReferenceSystem dstCrs = crsFactory.createFromName("EPSG:5179");
            CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
            CoordinateTransform transform = ctFactory.createTransform(srcCrs, dstCrs);
            transform.transform(srcCoord, dstCoord);
            coordinates[i] = new Coordinate(dstCoord.x, dstCoord.y);
        }
        return coordinates;
    }

    // - 실면적 계산
    public double calcArea(Polygon polygon){
        Map<String, List<List<Double>>> pointList = polygonService.polygonToPoints(polygon);
        Map<String, Coordinate[]> coordinateList = new HashMap<>(pointList.size());
        Set<String> keys = pointList.keySet();
        for(String key : keys){
            coordinateList.put(key, transformCoordinates(pointList.get(key)));
        }
        return polygonService.pointsToPolygon(coordinateList).getArea();
    }

    // - 실거리 계산
    public double calcDistance(Coordinate[] coordinates){
        return polygonService.createLineString(coordinates).getLength();
    }

    // - 겹치는 면적 계산
    public double calcAreaSum(List<Polygon> polygons){
        double sumArea = 0D;
        for(Polygon p : polygons){
            sumArea += calcArea(p);
        }
        return sumArea;
    }

    // - 폴리곤 연산 이후 결과 List<Polygon>
    public List<Polygon> geometryToPolygons(Geometry geometry){
        return Stream.of(geometry)
                .flatMap(geom -> {
                    if (geom instanceof Polygon) {
                        return Stream.of((Polygon) geom);
                    } else if (geom instanceof MultiPolygon) {
                        return IntStream.range(0, ((MultiPolygon) geom).getNumGeometries())
                                .mapToObj(((MultiPolygon) geom)::getGeometryN)
                                .filter(g -> g instanceof Polygon)
                                .map(g -> (Polygon) g);
                    } else {
                        return Stream.empty();
                    }
                })
                .toList();
    }

    private MoveHistory convertToEntity(GameRequestDTO gameRequestDTO, double distance, Polygon polygon) {
        return MoveHistory.builder()
                .authUuid(gameRequestDTO.getAuthUuid())
                .area(polygon)
                .distance(distance)
                .startTime(gameRequestDTO.getStartTime())
                .endTime(gameRequestDTO.getEndTime())
                .build();
    }

    private GameResponseDTO convertToDTO(MoveHistory moveHistory, double area, Set<String> stolenTeamNames) {
        return GameResponseDTO.builder()
                .id(moveHistory.getId())
                .authUuid(moveHistory.getAuthUuid())
                .distance(moveHistory.getDistance())
                .area(area)
                .startTime(moveHistory.getStartTime())
                .endTime(moveHistory.getEndTime())
                .stolenTeamNames(stolenTeamNames)
                .build();
    }

    private UserMoveHistoryResponseDTO convertToUserMoveHistoryDTO(MoveHistory moveHistory) {
        return UserMoveHistoryResponseDTO.builder()
                .distance(moveHistory.getDistance())
                .startTime(moveHistory.getStartTime())
                .endTime(moveHistory.getEndTime())
                .build();
    }
}

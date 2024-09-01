package com.mongddangnaeddang.MNServer.redis.service;

import com.mongddangnaeddang.MNServer.client.UTRClient;
import com.mongddangnaeddang.MNServer.game.entity.BackupMap;
import com.mongddangnaeddang.MNServer.game.repository.BackupMapRepository;
import com.mongddangnaeddang.MNServer.game.service.PolygonService;
import com.mongddangnaeddang.MNServer.redis.dto.PolygonDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.MapRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.TeamRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.UserRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.response.*;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Polygon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class RedisServiceImpl implements RedisService{

    private final UTRClient utrClient;
    private final PolygonService polygonService;
    private final BackupMapRepository backupMapRepository;
    private RedisTemplate<String, Object> redisTemplate;
    private HashOperations<String, Object, Object> hashOperations;
    private ZSetOperations<String, Object> zSetOperations;
    private ListOperations<String, Object> listOperations;

    @Autowired
    public void setRedisTemplate(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
        this.hashOperations = redisTemplate.opsForHash();
        this.listOperations = redisTemplate.opsForList();
        this.zSetOperations = redisTemplate.opsForZSet();
    }

    // - 맵 주변 영역 반환
    @Override
    public List<MapResponseDTO> getSurroundingArea(MapRequestDTO mapRequestDTO) {
        // 입력 받은 좌표로 영역 Polygon 생성
        Coordinate[] coordinates = new Coordinate[] {
                new Coordinate(mapRequestDTO.getLeftTop().get(0), mapRequestDTO.getLeftTop().get(1)),
                new Coordinate(mapRequestDTO.getRightTop().get(0), mapRequestDTO.getRightTop().get(1)),
                new Coordinate(mapRequestDTO.getRightBottom().get(0), mapRequestDTO.getRightBottom().get(1)),
                new Coordinate(mapRequestDTO.getLeftBottom().get(0), mapRequestDTO.getLeftBottom().get(1)),
                new Coordinate(mapRequestDTO.getLeftTop().get(0), mapRequestDTO.getLeftTop().get(1))
        };
        Polygon mapPolygon = polygonService.createPolygon(coordinates);

        // 겹치는 폴리곤들 반환
        List<PolygonDTO> polygons = getMap(mapPolygon);
        List<MapResponseDTO> mapResponseDTOs = new ArrayList<>();
        int idx = 1;
        for(PolygonDTO polygon : polygons){
            ResponseEntity<TeamDetailResponseDTO> teamDetail = utrClient.getTeamDetail(Integer.parseInt(polygon.getTeamId()));
            Map<String, List<List<Double>>> polygonPoints = polygonService.polygonToPoints(polygon.getPolygon());
            List<List<List<Double>>> area = new ArrayList<>();
            Set<String> keys = polygonPoints.keySet();
            for(String key : keys){
                List<List<Double>> polygonPoint = polygonPoints.get(key);
                area.add(polygonPoint);
            }
            mapResponseDTOs.add(convertToMapDTO("polygon"+(idx++), polygon.getTeamId(),teamDetail, area));
        }
        return mapResponseDTOs;
    }

    // - 주어진 폴리곤과 전체 폴리곤에 대해 intersect 연산
    @Override
    public List<PolygonDTO> getMap(Polygon basePolygon){
        // 전체 팀 돌면서 비교 연산 수행
        List<PolygonDTO> polygons = new ArrayList<>();
        Set<String> teamId = getTeamIds(0);
        String date = calcNowDate(0);

        for(String id : teamId){
            List<String> polygonWKTs = extractPolygons(id.replace("team_id_"+date+":",""));
            for(String polygonWKT : polygonWKTs){
                Polygon polygon = polygonService.polygonWKTToPolygon(polygonWKT);
                if(basePolygon.intersects(polygon)) {
                    polygons.add(new PolygonDTO(id.replace("team_id_"+date+":", ""), polygon));
                }
            }
        }
        return polygons;
    }

    @Scheduled(cron = "0 0 0 1 * ?")
    @Override
    public void backupToMap() {
        List<TeamSumResponseDTO> teamSumResponseDTOS = getAllTeams(-1);
        LocalDateTime today = LocalDate.now().atStartOfDay(); // 오늘 자정 시간
        for(TeamSumResponseDTO team : teamSumResponseDTOS){
            BackupMap backupMap = convertToMapEntity(team);
            backupMap.setCreatedTime(today);
            backupMapRepository.save(backupMap);
        }
    }

    // - 팀 정보 생성
    @Override
    public TeamSumResponseDTO insertTeam(TeamRequestDTO teamRequestDTO) {
        String id = teamRequestDTO.getId();
        String date = calcNowDate(0);
        hashOperations.put("team_id_"+date+":"+id, "area_sum", teamRequestDTO.getArea().toString());
        hashOperations.put("team_id_"+date+":"+id, "distance_sum", teamRequestDTO.getDistance().toString());
        listOperations.rightPush(id + "_polygons_"+date, teamRequestDTO.getPolygon());
        Date expiration = calcExpireDate(1);
        redisTemplate.expireAt("team_id_"+date+":"+id, expiration);
        redisTemplate.expireAt(id + "_polygons_"+date, expiration);
        return convertToTeamSumDTO(id, teamRequestDTO.getArea().toString(), teamRequestDTO.getDistance().toString());
    }

    @Override
    public List<TeamSumResponseDTO> getAllTeams(int mm) {
        List<TeamSumResponseDTO> teams = new ArrayList<>();
        Set<String> teamId = getTeamIds(mm);
        String date = calcNowDate(mm);

        for(String id : teamId){
            String team = id.replace("team_id_"+date+":","");
            String areaSum = (String) hashOperations.get(id, "area_sum");
            String distanceSum = (String) hashOperations.get(id, "distance_sum");
            teams.add(new TeamSumResponseDTO(team, areaSum, distanceSum));
        }

        return teams;
    }

    // - 팀 정보 조회
    @Override
    public TeamResponseDTO getTeam(String id) {
        if(!isTeamExists(id)) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "팀 정보를 찾을 수 없습니다.");
        String date = calcNowDate(0);

        String areaSum = (String) hashOperations.get("team_id_"+date+":"+id, "area_sum");
        String distanceSum = (String) hashOperations.get("team_id_"+date+":"+id, "distance_sum");
        List<String> polygons =  extractPolygons(id);

        return convertToTeamDTO(id, areaSum, distanceSum, polygons);
    }
    
    // - 팀 정보 수정
    @Override
    public TeamSumResponseDTO updateTeam(TeamRequestDTO teamRequestDTO) {
        String id = teamRequestDTO.getId();
        String date = calcNowDate(0);
        
        // 존재하는 팀 정보인지 확인
        if(!isTeamExists(id)) return insertTeam(teamRequestDTO);

        // areaSum, distanceSum Get
        String areaSum = (String) hashOperations.get("team_id_"+date+":"+ id, "area_sum");
        String distanceSum = (String) hashOperations.get("team_id_"+date+":"+ id, "distance_sum");

        // areaSum, distanceSum Update
        Double newAreaSum = Double.parseDouble(areaSum) + teamRequestDTO.getArea();
        Double newDistanceSum = Double.parseDouble(distanceSum) + teamRequestDTO.getDistance();

        // 값 업데이트
        hashOperations.put("team_id_"+date+":"+ id, "area_sum", newAreaSum.toString());
        hashOperations.put("team_id_"+date+":"+ id, "distance_sum", newDistanceSum.toString());
        if(teamRequestDTO.getPolygon()!=null) listOperations.rightPush(id + "_polygons_"+date, teamRequestDTO.getPolygon());
        return convertToTeamSumDTO(id, newAreaSum.toString(), newDistanceSum.toString());
    }

    @Override
    public void deleteTeam(String teamId) {
        String date = calcNowDate(0);
        redisTemplate.delete("team_id_"+date+":"+teamId);
        redisTemplate.delete(teamId+"_polygons_"+date);
    }

    @Override
    public void deleteTeamPolygon(String teamId, Polygon polygon) {
        String polygonWKT = polygonService.polygonToPolygonWKT(polygon);
        listOperations.remove(teamId+"_polygons_"+calcNowDate(0), 1, polygonWKT);
    }

    // - 유저 정보 생성
    @Override
    public UserResponseDTO insertUser(UserRequestDTO userRequestDTO){
        String authUuid = userRequestDTO.getAuthUuid();
        hashOperations.put("auth_UUID:" + authUuid, "distance_sum", userRequestDTO.getDistance().toString());
        return convertToUserDTO(authUuid, userRequestDTO.getDistance().toString());
    }

    // - 유저 정보 조회
    @Override
    public UserResponseDTO getUser(String authUuid) {
        String distanceSum = "0.0";
        if(isUserExists(authUuid)) distanceSum = (String) hashOperations.get("auth_UUID:" + authUuid, "distance_sum");

        return convertToUserDTO(authUuid, distanceSum);
    }

    @Override
    public List<UserResponseDTO> getAllUsers() {
        List<UserResponseDTO> users = new ArrayList<>();
        Set<String> userIds = getUserIds();
        for(String userId : userIds){
            String id = userId.replace("auth_UUID:","");
            String distanceSum = (String) hashOperations.get(userId, "distance_sum");
            users.add(new UserResponseDTO(id, distanceSum));
        }
        return users;
    }

    // - 유저 정보 수정
    @Override
    public UserResponseDTO updateUser(UserRequestDTO userRequestDTO) {
        String id = userRequestDTO.getAuthUuid();

        // 존재하는 유저 정보인지 확인
        if(!isUserExists(id)) return insertUser(userRequestDTO);

        // distanceSum Get & Update
        String distanceSum = (String) hashOperations.get("auth_UUID:" + userRequestDTO.getAuthUuid(), "distance_sum");
        Double newDistanceSum = Double.parseDouble(distanceSum) + userRequestDTO.getDistance();
        
        // 값 업데이트
        hashOperations.put("auth_UUID:" + id, "distance_sum", newDistanceSum.toString());
        return convertToUserDTO(userRequestDTO.getAuthUuid(), newDistanceSum.toString());
    }

    // - 특정 팀 랭킹 반환
    @Override
    public TeamRankResponseDTO getTeamRanking(String teamId) {
        String date = calcNowDate(-1);
        double areaSum =  Optional.ofNullable(zSetOperations.score("team_area_" + date, teamId)).orElse(0.0);
        long areaRank = Optional.ofNullable(zSetOperations.reverseRank("team_area_"+date, teamId)).orElse(-1L)+1;
        double distanceSum = Optional.ofNullable(zSetOperations.score("team_distance_"+date, teamId)).orElse(0.0);
        long distanceRank = Optional.ofNullable(zSetOperations.reverseRank("team_distance_"+date, teamId)).orElse(-1L)+1;

        return new TeamRankResponseDTO(teamId, areaSum, areaRank, distanceSum, distanceRank);
    }

    // - 조건에 맞는 팀 랭킹 반환
    @Override
    public List<AllTeamRankResponseDTO> getAllTeamRanking(String type, int range) {
        List<AllTeamRankResponseDTO> teamRanks = new ArrayList<>();
        String date = calcNowDate(-1);
        Set<ZSetOperations.TypedTuple<Object>> teams = zSetOperations.reverseRangeWithScores("team_"+type+"_"+date, 0, range);

        if (teams != null) {
            int rank = 1;
            for (ZSetOperations.TypedTuple<Object> team : teams) {
                teamRanks.add(new AllTeamRankResponseDTO((String) team.getValue(), team.getScore(), rank++));
            }
        }
        return teamRanks;
    }

    // - 팀 랭킹 계산
    @Scheduled(cron = "0 0 3 1 * ?") // 초 분 시 일 월 요일
    @Override
    public void calcTeamRanking() {
        List<TeamSumResponseDTO> teams = getAllTeams(0);
        String date = calcNowDate(-1);

        for (TeamSumResponseDTO team : teams) {
            zSetOperations.add("team_area_"+date, team.getTeamId(), Double.parseDouble(team.getAreaSum()));
            zSetOperations.add("team_distance_"+date, team.getTeamId(), Double.parseDouble(team.getDistanceSum()));
        }
        Date expiration = calcExpireDate(2);
        redisTemplate.expireAt("team_area_"+date, expiration);
        redisTemplate.expireAt("team_distance_"+date, expiration);
    }
    
    // - Top 100 유저 랭킹 반환
    @Override
    public List<UserRankResponseDTO> getAllUserRanking() {
        List<UserRankResponseDTO> userRanks = new ArrayList<>();
        String date = calcNowDate(-1);

        Set<ZSetOperations.TypedTuple<Object>> users = zSetOperations.reverseRangeWithScores("user_distance_"+date, 0, 99);
        if (users != null) {
            int rank = 1;
            for (ZSetOperations.TypedTuple<Object> user : users) {
                userRanks.add(new UserRankResponseDTO((String) user.getValue(), user.getScore(), rank++));
            }
        }
        return userRanks;
    }

    // - 유저 랭킹 계산
    @Scheduled(cron = "0 0 3 1 * ?") // 초 분 시 일 월 요일
    @Override
    public void calcUserRanking() {
        List<UserResponseDTO> users = getAllUsers();
        String date = calcNowDate(-1);

        for(UserResponseDTO user : users){
            zSetOperations.add("user_distance_"+date, user.getAuthUuid(), Double.parseDouble(user.getDistanceSum()));
        }
        Date expiration = calcExpireDate(2);
        redisTemplate.expireAt("user_distance_"+date, expiration);
    }

    // - 존재하는 팀인지 확인
    private boolean isTeamExists(String teamId) {
        return redisTemplate.hasKey("team_id_"+calcNowDate(0)+":" + teamId);
    }

    // - 존재하는 유저인지 확인
    private boolean isUserExists(String authUuid) {
        return redisTemplate.hasKey("auth_UUID:" + authUuid);
    }

    // - 팀 id 반환
    private Set<String> getTeamIds(int mm){
        return redisTemplate.keys("team_id_"+calcNowDate(mm)+":*");
    }

    // - 유저 uuid 반환
    private Set<String> getUserIds(){
        return redisTemplate.keys("auth_UUID:*");
    }

    // - polygons 추출
    private List<String> extractPolygons(String teamId){
        return listOperations.range(teamId+"_polygons_"+calcNowDate(0), 0, -1).stream()
                .map(obj -> (String) obj)
                .collect(Collectors.toList());
    }

    // - 키 만료 기한 설정
    public Date calcExpireDate(int mm) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, mm); // mm 달 뒤
        calendar.set(Calendar.DAY_OF_MONTH, 2); // 2일
        calendar.set(Calendar.HOUR_OF_DAY, 0); // 자정
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

    // - 현재 날짜 계산
    public String calcNowDate(int mm){
        LocalDate today = LocalDate.now();
        LocalDate findMonth = today.plusMonths(mm);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");
        return findMonth.format(formatter);
    }

    private TeamResponseDTO convertToTeamDTO(String teamId, String areaSum, String distanceSum, List<String> polygons){
        return TeamResponseDTO.builder()
                .teamId(teamId)
                .areaSum(areaSum)
                .distanceSum(distanceSum)
                .polygons(polygons)
                .build();
    }

    private TeamSumResponseDTO convertToTeamSumDTO(String teamId, String areaSum, String distanceSum){
        return TeamSumResponseDTO.builder()
                .teamId(teamId)
                .areaSum(areaSum)
                .distanceSum(distanceSum)
                .build();
    }

    private UserResponseDTO convertToUserDTO(String authUuid, String distanceSum){
        return UserResponseDTO.builder()
                .authUuid(authUuid)
                .distanceSum(distanceSum)
                .build();
    }

    private BackupMap convertToMapEntity(TeamSumResponseDTO teamSumResponseDTO){
        return BackupMap.builder()
                .teamId(Integer.parseInt(teamSumResponseDTO.getTeamId()))
                .areaSum(Double.parseDouble(teamSumResponseDTO.getAreaSum()))
                .distanceSum(Double.parseDouble(teamSumResponseDTO.getDistanceSum()))
                .build();
    }

    private MapResponseDTO convertToMapDTO(String id, String teamId, ResponseEntity<TeamDetailResponseDTO> teamDetail, List<List<List<Double>>> area) {
        return MapResponseDTO.builder()
                .id(id)
                .teamId(teamId)
                .name(teamDetail.getBody().getName())
                .color(teamDetail.getBody().getColor())
                .logo(teamDetail.getBody().getLogo())
                .area(area)
                .build();
    }
}

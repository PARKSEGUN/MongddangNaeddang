package com.mongddangnaeddang.UTRServer.team.api.service;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.auth.db.repository.UserProfileRepository;
import com.mongddangnaeddang.UTRServer.client.team.MNServerClient;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.request.UserContributionFeignReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamDetailRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.AlarmToUserReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamCreatePostReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamUpdateRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import com.mongddangnaeddang.UTRServer.team.db.entity.Team;
import com.mongddangnaeddang.UTRServer.team.db.entity.TeamDocument;
import com.mongddangnaeddang.UTRServer.team.db.mapper.TeamMemberCountMapper;
import com.mongddangnaeddang.UTRServer.team.db.repository.TeamRepository;
import com.mongddangnaeddang.UTRServer.team.db.repository.TeamSearchRepository;
import com.mongddangnaeddang.UTRServer.user.db.entity.teamUser.TeamUser;
import com.mongddangnaeddang.UTRServer.user.db.repository.TeamUserRepository;
import com.sun.jdi.request.InvalidRequestStateException;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;

@RequiredArgsConstructor
@Service("teamService")
public class TeamServiceImpl implements TeamService {
    private static final int NO_TEAM_VALUE = -1;
    //    public static final String IMAGE_DIRECTORY_PATH = "/app/data/upload/team_logo/";
    public static final String IMAGE_DIRECTORY_PATH = "C:\\Users\\SSAFY\\Desktop\\upload\\";
    private static final Logger log = LoggerFactory.getLogger(TeamServiceImpl.class);
    private final UserProfileRepository userProfileRepository;
    private final TeamRepository teamRepository;
    private final TeamSearchRepository teamSearchRepository;
    private final MNServerClient mnServerClient;
    private final TeamUserRepository teamUserRepository;

    /**
     * 팀 정보를 요청받고 새로운 팀을 생성
     *
     * @param teamCreatePostReq 요청받은 데이터
     * @param imgPath           요청받은 이미지의 주소
     * @return 만들어진 새로운 Team 객체
     */
    @Override
    @Transactional
    public Team createTeam(TeamCreatePostReq teamCreatePostReq, String imgPath) {
        Team newTeam = createAndSave(teamCreatePostReq, imgPath);
        teamUserRepository.save(new TeamUser(new Timestamp(System.currentTimeMillis()), teamCreatePostReq.getAuthUuid(), newTeam.getTeamId()));
        saveTeamDocument(newTeam);
        UserProfile user = userProfileRepository.findById(teamCreatePostReq.getAuthUuid()).orElseThrow(RuntimeException::new);
        user.setIsLeader(true);
        user.setTeamId(newTeam.getTeamId());
        // firebase alarm 보내기
//        mnServerClient.alarmByTeamCreate(teamCreatePostReq.getTeamName(), teamCreatePostReq.getAuthUuid());
        return newTeam;
    }

    private void saveTeamDocument(Team newTeam) {
        TeamDocument teamDocument = newTeam.toDocument();
        teamDocument.setTeamId(newTeam.getTeamId());
        teamSearchRepository.save(teamDocument);
    }

    private Team createAndSave(TeamCreatePostReq teamCreatePostReq, String imgPath) {
        Team team = teamCreatePostReq.toTeam();
        team.setLogo(imgPath);
        return teamRepository.save(team);
    }

    /**
     * 이미지를 로컬에 저장
     *
     * @param teamLogo 요청받은 사진 정보
     * @return 사진을 저장시킨 위치(주소)
     * @throws IOException 저장시에 발생하는 예외 처리
     */
    @Override
    public String uploadImg(MultipartFile teamLogo) throws IOException {
        makeDirectory();
        return saveImageFile(teamLogo);

    }

    private static String saveImageFile(MultipartFile teamLogo) throws IOException {
        System.out.println(teamLogo.getOriginalFilename());
        String fullImagePath = IMAGE_DIRECTORY_PATH + System.currentTimeMillis() + "_" + teamLogo.getOriginalFilename();
        teamLogo.transferTo(new File(fullImagePath));
        return fullImagePath;
    }

    private static void makeDirectory() {
        File saveFile = new File(IMAGE_DIRECTORY_PATH);
        if (!saveFile.exists()) {
            saveFile.mkdirs();
        }
    }

    /**
     * 팀 ID로 팀의 상세 정보 전달
     *
     * @param teamId 요청받은 팀 ID
     * @return 팀 상세 정보
     */
    @Override
    public TeamRes detailByTeamId(int teamId) {
        Team team = teamRepository.findById(teamId).orElseThrow(() -> new RuntimeException("팀이 존재하지 않습니다!"));
        TeamDetailRankFeignRes teamDetailRankFeignRes = mnServerClient.getTeamRankByTeamId(team.getTeamId());
        TeamRes teamRes = team.toTeamRes();
        teamRes.setMemberCount(userProfileRepository.countByTeamId(teamRes.getTeamId()));
        teamRes.setMetrics(teamDetailRankFeignRes);
        return teamRes;
    }

    /**
     * 팀 ID로 팀의 모든 인원 정보 전달
     *
     * @param teamId 요청받은 팀 ID
     * @return 요청받은 팀에 속하는 users(List)
     */
    @Override
    public List<UserRes> getUsersByTeamId(int teamId) {
        List<UserProfile> usersResult = userProfileRepository.findByTeamId(teamId);
        List<UserRes> userResList = new ArrayList<>();
        for (UserProfile userProfile : usersResult) {
            UserRes userRes = userProfile.toUserRes();
            String authUuid = userProfile.getAuthUuid();
            log.error(userRes.toString());
            TeamUser teamUser = teamUserRepository.findByAuthUuidAndTeamId(authUuid, teamId).orElseThrow(NoSuchElementException::new);
            userRes.setDistance(mnServerClient.getTeamContribution(new UserContributionFeignReq(authUuid, teamUser.getJoinAt())).getDistance());
            userResList.add(userRes);
        }
        return userResList;
    }

    /**
     * 팀 ID로 팀이 혼자인지 판별
     *
     * @param teamId 요청받은 Team ID
     * @return 팀 인원이 혼자인지에 대한 boolean 값
     */
    @Override
    public boolean isTeamMemberOnlyOne(int teamId) {
        return userProfileRepository.findByTeamId(teamId).size() == 1;
    }

    /**
     * 팀 ID에 해당하는 팀 제거
     *
     * @param teamId Team ID 값
     */
    @Override
    @Transactional
    public void deleteTeamById(int teamId) {
        UserProfile leader = userProfileRepository.findByTeamIdAndIsLeader(teamId, true).orElseThrow(() -> new NoSuchElementException("팀의 리더가 존재하지 않습니다"));
        leader.setTeamId(NO_TEAM_VALUE);
        Team team = teamRepository.findById(teamId).orElseThrow(RuntimeException::new);
        teamSearchRepository.deleteByTeamId(teamId);
        mnServerClient.alarmByTeamDelete(team.getName(), leader.getFcmToken());
        teamRepository.deleteById(teamId);
        mnServerClient.deleteTeamOfRedis(teamId);
    }

    /**
     * user를 팀에 가입
     *
     * @param teamUpdateRes 요청받은 user와 team의 정보
     */
    @Override
    @Transactional
    public void signUp(TeamUpdateRes teamUpdateRes) {
        AlarmToUserReq alarmToUserReq = updateUserInfo(teamUpdateRes, teamUpdateRes.getTeamId());
        mnServerClient.alarmByJoin(alarmToUserReq);
    }

    /**
     * user를 팀에서 제외
     *
     * @param teamUpdateRes 요청받은 user와 team의 정보
     */
    @Override
    @Transactional
    public void leaveTeam(TeamUpdateRes teamUpdateRes) {
        AlarmToUserReq alarmToUserReq = updateUserInfo(teamUpdateRes, NO_TEAM_VALUE);
        mnServerClient.alarmByLeave(alarmToUserReq);
    }

    /**
     * 팀 ID 값으로 팀 이름 응답
     *
     * @param teamId 팀 ID 값
     * @return 팀 세부 정보 응답
     */
    @Override
    public TeamRes getTeamNameByTeamId(int teamId) {
        Team team = teamRepository.findById(teamId).orElseThrow(() -> new RuntimeException("일치하는 팀이 없습니다"));
        return team.toTeamRes();
    }


    private AlarmToUserReq updateUserInfo(TeamUpdateRes teamUpdateRes, int updateTeamId) {
        UserProfile leader = userProfileRepository.findByTeamIdAndIsLeader(teamUpdateRes.getTeamId(), true).orElseThrow(NoSuchElementException::new);
        UserProfile member = userProfileRepository.findById(teamUpdateRes.getAuthUuid()).orElseThrow(NoSuchElementException::new);
        Team team = teamRepository.findById(teamUpdateRes.getTeamId()).orElseThrow(NoSuchElementException::new);
        System.out.println(leader.toString());
        System.out.println(member.toString());
        if (updateTeamId != NO_TEAM_VALUE && member.getTeamId() != NO_TEAM_VALUE) {
            throw new InvalidRequestStateException("현재 유저의 팀이 존재합니다!");
        }
        if (updateTeamId == NO_TEAM_VALUE && member.getTeamId() == NO_TEAM_VALUE) {
            throw new InvalidRequestStateException("현재 유저의 팀이 존재하지 않습니다!");
        }
        if (updateTeamId == NO_TEAM_VALUE && member.getTeamId() != teamUpdateRes.getTeamId()) {
            throw new InvalidRequestStateException("탈퇴하려는 팀과 요청이 일치하지 않습니다!");
        }
        AlarmToUserReq alarmToUserReq = AlarmToUserReq.of(leader, member, team.getName());
        member.setTeamId(updateTeamId);
        userProfileRepository.save(member);
        TeamUser teamUser = new TeamUser();
        teamUser.setTeamId(updateTeamId);
        teamUser.setAuthUuid(member.getAuthUuid());
        teamUser.setJoinAt(new Timestamp(System.currentTimeMillis()));
        teamUserRepository.save(teamUser);
        return alarmToUserReq;
    }

    /**
     * 요청받은 팀 ID에 맞는 팀 멤버 수 응답
     *
     * @param teamIds 팀 ID(List)
     * @return 팀 멤버수 <ID, 멤버수> (Map)
     */
    @Override
    public Map<Integer, Integer> createCountMemberMap(List<Integer> teamIds) {
        Map<Integer, Integer> countByTeamId = new HashMap<>();
        List<TeamMemberCountMapper> teamMemberCountMappers = userProfileRepository.countByTeamIds(teamIds);
        for (TeamMemberCountMapper teamMemberCountMapper : teamMemberCountMappers) {
            countByTeamId.put(teamMemberCountMapper.getTeamId(), Math.toIntExact(teamMemberCountMapper.getCount()));
        }
        return countByTeamId;
    }


    @Override
    public int getTeamIdByTeamName(String teamName) {
        int teamId = teamRepository.findTeamIdByName(teamName);
        return teamId;
    }

    @Override
    public String getLeaderAuthUuid(int teamId) {
        UserProfile userProfile = userProfileRepository.findByTeamIdAndIsLeader(teamId, true).orElseThrow(() -> new NoSuchElementException("teamId에 Leader가 존재하지 않습니다."));
        return userProfile.getAuthUuid();

    }


}

package com.mongddangnaeddang.UTRServer.team.api.service;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.auth.db.repository.UserProfileRepository;
import com.mongddangnaeddang.UTRServer.client.team.MNServerClient;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.UserRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.RankRes;
import com.mongddangnaeddang.UTRServer.team.db.entity.Team;
import com.mongddangnaeddang.UTRServer.team.db.repository.TeamRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class RankServiceImpl implements RankService {

    private final MNServerClient mnServerClient;
    private final TeamRepository teamRepository;
    private final TeamService teamService;
    private final UserProfileRepository userProfileRepository;

    @Override
    public Map<Integer, TeamRankFeignRes> createTeamRankMap(List<TeamRankFeignRes> teamRanks) {
        Map<Integer, TeamRankFeignRes> teamRankResByTeamId = new HashMap<>();
        for (TeamRankFeignRes teamRank : teamRanks) {
            teamRankResByTeamId.put(teamRank.getTeamId(), teamRank);
        }
        return teamRankResByTeamId;
    }

    @Override
    public Map<String, UserRankFeignRes> createUserRankMap(List<UserRankFeignRes> userRanks) {
        Map<String, UserRankFeignRes> userRankResMap = new HashMap<>();
        for (UserRankFeignRes userRankFeignRes : userRanks) {
            userRankResMap.put(userRankFeignRes.getAuthUuid(), userRankFeignRes);
        }
        return userRankResMap;
    }

    @Override
    public List<RankRes> getUserRankByDistance() {
        List<UserRankFeignRes> userRankFeignResList = mnServerClient.getUserRank();
        List<RankRes> userRankList = new ArrayList<>();
        Map<String, UserRankFeignRes> userRankMap = createUserRankMap(userRankFeignResList);
        List<String> teamIds = userRankFeignResList.stream().map(UserRankFeignRes::getAuthUuid).toList();
        List<UserProfile> userProfiles = userProfileRepository.findAllById(teamIds);
        for (UserProfile userProfile : userProfiles) {
            RankRes rankRes = new RankRes();
            rankRes.setComment(userProfile.getComment());
            rankRes.setName(userProfile.getNickname());
            rankRes.setLogo(userProfile.getImageAddress());
            rankRes.setUnit(userRankMap.get(userProfile.getAuthUuid()).getUnit());
            userRankList.add(rankRes);
        }
        userRankList.sort(Comparator.comparingDouble(RankRes::getUnit).reversed());
        return userRankList;
    }


    /*
     *   리팩토링 필요해보임
     * */
    @Override
    public List<RankRes> getTeamRank(String type, String range) {
        List<TeamRankFeignRes> teamRanks = mnServerClient.getTeamRank(type, range);
        List<RankRes> rankResList = new ArrayList<>();
        Map<Integer, TeamRankFeignRes> teamRankMap = createTeamRankMap(teamRanks);
        List<Integer> teamIds = teamRanks.stream().map(TeamRankFeignRes::getTeamId).toList();
        List<Team> teams = teamRepository.findAllById(teamIds);
        for (Team team : teams) {
            RankRes rankRes = new RankRes();
            rankRes.setName(team.getName());
            rankRes.setLogo(team.getLogo());
            rankRes.setComment(team.getComment());
            rankRes.setUnit(teamRankMap.get(team.getTeamId()).getUnit());
            rankResList.add(rankRes);
        }
        rankResList.sort(Comparator.comparingDouble(RankRes::getUnit).reversed());
        return rankResList;
    }

}

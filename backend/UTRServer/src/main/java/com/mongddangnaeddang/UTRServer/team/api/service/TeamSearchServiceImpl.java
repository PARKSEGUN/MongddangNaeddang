package com.mongddangnaeddang.UTRServer.team.api.service;

import com.mongddangnaeddang.UTRServer.client.team.MNServerClient;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamDetailRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamSearchPostReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import com.mongddangnaeddang.UTRServer.team.db.entity.TeamDocument;
import com.mongddangnaeddang.UTRServer.team.db.repository.TeamSearchRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class TeamSearchServiceImpl implements TeamSearchService {

    private final TeamSearchRepository teamSearchRepository;
    private final RankService rankService;
    private final TeamService teamService;
    private final MNServerClient gameClient;

    @Override
    public List<TeamRes> searchTeamByName(TeamSearchPostReq teamSearchPostReq) {
        List<TeamDocument> teamDocumentResult = teamSearchRepository.findByNameStartingWith(teamSearchPostReq.getKeyword());
        List<Integer> teamIds = teamDocumentResult.stream().map(TeamDocument::getTeamId).toList();
        //        //멤버수를 찾기위한 Map 구현
        Map<Integer, Integer> countByTeamId = teamService.createCountMemberMap(teamIds);
        //        //게임 기록에 대한 정보를 찾기위한 Map 2개 구현
        Map<Integer, TeamRankFeignRes> teamDistanceRankMap = rankService.createTeamRankMap(gameClient.getTeamRank("distance", "0"));
        Map<Integer, TeamRankFeignRes> teamAreaRankMap = rankService.createTeamRankMap(gameClient.getTeamRank("area", "0"));

        List<TeamRes> teamResResult = new ArrayList<>(teamDocumentResult.stream().map(teamDocument -> {
            int teamId = teamDocument.getTeamId();
            return teamDocument.toTeamRes(
                    countByTeamId.getOrDefault(teamId, 0),
                    TeamDetailRankFeignRes.of(teamDistanceRankMap.getOrDefault(teamId, new TeamRankFeignRes(teamId)), teamAreaRankMap.getOrDefault(teamId, new TeamRankFeignRes(teamId)))
            );
        }).toList());

        teamResResult.sort(Comparator.comparingDouble((teamRes) -> -teamRes.getSortValue(teamSearchPostReq.getSortType())));
        return teamResResult;
    }
}

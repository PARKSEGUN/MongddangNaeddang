package com.mongddangnaeddang.UTRServer.team.api.service;

import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.UserRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.RankRes;

import java.util.List;
import java.util.Map;

public interface RankService {


    Map<Integer, TeamRankFeignRes> createTeamRankMap(List<TeamRankFeignRes> teamRanks);

    Map<String, UserRankFeignRes> createUserRankMap(List<UserRankFeignRes> userRanks);

    List<RankRes> getUserRankByDistance();

    List<RankRes> getTeamRank(String type, String range);


}

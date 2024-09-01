package com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class TeamDetailRankFeignRes {

    @Schema(name = "teamId", example = "5")
    private int teamId;
    @Schema(name = "areaSum", example = "1324,1234")
    private double areaSum;
    @Schema(name = "areaRank", example = "5")
    private int areaRank;
    @Schema(name = "distanceSum", example = "1324,1234")
    private double distanceSum;
    @Schema(name = "distanceRank", example = "5")
    private int distanceRank;

    public static TeamDetailRankFeignRes of(TeamRankFeignRes teamDistanceRank, TeamRankFeignRes teamAreaRank) {
        TeamDetailRankFeignRes teamDetailRankFeignRes = new TeamDetailRankFeignRes();
        teamDetailRankFeignRes.setTeamId(teamDistanceRank.getTeamId());
        teamDetailRankFeignRes.setDistanceSum(teamDistanceRank.getUnit());
        teamDetailRankFeignRes.setDistanceRank(teamDistanceRank.getRank());
        teamDetailRankFeignRes.setAreaSum(teamAreaRank.getUnit());
        teamDetailRankFeignRes.setAreaRank(teamAreaRank.getRank());
        return teamDetailRankFeignRes;


    }
}

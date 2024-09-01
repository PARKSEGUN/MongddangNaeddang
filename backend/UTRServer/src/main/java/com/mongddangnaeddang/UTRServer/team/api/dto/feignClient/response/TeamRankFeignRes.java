package com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Schema
@NoArgsConstructor
@AllArgsConstructor
public class TeamRankFeignRes {

    @Schema(name = "teamId", example = "5")
    private int teamId;
    @Schema(name = "distanceSum", example = "234,234")
    private double unit = 0;
    @Schema(name = "distanceRank", example = "5")
    private int rank = 0;


    public TeamRankFeignRes(int teamId) {
        this.teamId = teamId;
    }
}

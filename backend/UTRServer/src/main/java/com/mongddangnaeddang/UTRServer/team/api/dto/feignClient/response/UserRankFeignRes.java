package com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class UserRankFeignRes {
    @Schema(name = "authUuid", example = "asdf1234")
    private String authUuid;
    @Schema(name = "distanceSum", example = "234,234")
    private double unit;
    @Schema(name = "distanceRank", example = "5")
    private int rank;

}

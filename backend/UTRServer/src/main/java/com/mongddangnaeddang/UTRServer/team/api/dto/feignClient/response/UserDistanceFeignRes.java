package com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class UserDistanceFeignRes {
    @Schema(name = "authUuid", example = "oasdpq28394oiasdh")
    private String authUuid;
    @Schema(name = "distanceSum", example = "1234.1234")
    private double distanceSum;
}

package com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Schema
@AllArgsConstructor
@NoArgsConstructor
public class UserContributionFeignRes {
    @Schema(name = "authUuid", example = "asdf1234")
    private String authUuid;
    @Schema(name = "teamId", example = "5")
    private int teamId;
    @Schema(name = "distance", example = "1234.1234")
    private double distance;
}
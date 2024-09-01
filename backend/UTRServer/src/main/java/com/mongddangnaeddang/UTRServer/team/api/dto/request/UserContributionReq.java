package com.mongddangnaeddang.UTRServer.team.api.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class UserContributionReq {
    @Schema(name = "authUuid", example = "asdf1234")
    private String authUuid;
    @Schema(name = "teamId", example = "5")
    private int teamId;
}

package com.mongddangnaeddang.UTRServer.team.api.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@AllArgsConstructor
@Schema
@ToString
public class TeamUpdateRes {
    @Schema(name = "authUuid", example = "sldknfy8989awioa")
    private String authUuid;
    @Schema(name = "teamId", example = "1")
    private int teamId;
}

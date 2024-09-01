package com.mongddangnaeddang.UTRServer.team.api.dto.request;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class TeamIdReq {
    @Schema(name = "teamId", example = "1")
    private int teamId;
}

package com.mongddangnaeddang.UTRServer.team.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class TeamAreaRankRes {
    @Schema(name = "name", example = "teamNameTest")
    private String name;
    @Schema(name = "comment", example = "잘난팀입니다")
    private String comment;
    @Schema(name = "logo", example = "test.jpg")
    private String logo;
    @Schema(name = "areaSum", example = "123.123")
    private double unit;
}

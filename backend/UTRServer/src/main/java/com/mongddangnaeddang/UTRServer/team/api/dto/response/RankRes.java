package com.mongddangnaeddang.UTRServer.team.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Schema
@ToString
public class RankRes {
    @Schema(name = "name", example = "teamNameTest")
    private String name;
    @Schema(name = "comment", example = "잘난팀입니다")
    private String comment;
    @Schema(name = "logo", example = "test.jpg")
    private String logo;
    @Schema(name = "distanceSum", example = "12.12")
    private double unit;
}

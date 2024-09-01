package com.mongddangnaeddang.UTRServer.team.api.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Schema
@ToString
public class TeamSearchPostReq {
    @Schema(name = "keyword", example = "team")
    private String keyword;

    @Schema(name = "sortType", example = "0")
    private int sortType;
}

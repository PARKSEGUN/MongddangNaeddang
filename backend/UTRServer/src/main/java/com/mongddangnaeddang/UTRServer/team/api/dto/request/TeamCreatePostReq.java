package com.mongddangnaeddang.UTRServer.team.api.dto.request;

import com.mongddangnaeddang.UTRServer.team.db.entity.Team;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

@Schema(name = "TeamCreatePostRequest", description = "팀 생성 객체")
public class TeamCreatePostReq {
    @Schema(name = "authUuid", example = "qkrtprjs1324")
    private String authUuid;
    @Schema(name = "teamName", example = "ssafy팀")
    private String teamName;
    @Schema(name = "description", example = "ssafy출신만 들어오세요!")
    private String description;
    @Schema(name = "teamColor", example = "#0000FF")
    private String teamColor;

    public Team toTeam() {
        Team team = new Team();
        team.setName(teamName);
        team.setColor(teamColor);
        team.setComment(description);
        return team;
    }


}

package com.mongddangnaeddang.UTRServer.team.db.entity;

import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamDetailRankFeignRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;
import org.springframework.data.elasticsearch.annotations.Setting;

@Getter
@Setter
@ToString
@Document(indexName = "team")
@Setting(replicas = 0)

public class TeamDocument {

    @Id
    private String id;

    @Field(type = FieldType.Integer, index = false)
    private int teamId;

    @Field(type = FieldType.Text, analyzer = "nori")
    private String name;

    @Field(type = FieldType.Text, index = false)
    private String comment;

    @Field(type = FieldType.Text, index = false)
    private String color;

    @Field(type = FieldType.Text, index = false)
    private String logo;


    public TeamRes toTeamRes(int teamMemberCount, TeamDetailRankFeignRes teamDetailRankFeignRes) {
        TeamRes teamRes = new TeamRes();
        teamRes.setTeamId(teamId);
        teamRes.setName(name);
        teamRes.setComment(comment);
        teamRes.setColor(color);
        teamRes.setLogo(logo);
        teamRes.setMemberCount(teamMemberCount);
        teamRes.setMetrics(teamDetailRankFeignRes);
        return teamRes;
    }


}

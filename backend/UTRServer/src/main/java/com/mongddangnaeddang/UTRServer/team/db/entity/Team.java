package com.mongddangnaeddang.UTRServer.team.db.entity;


import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class Team {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int teamId;
    String name;
    String comment;
    String color;
    String logo;

    public TeamDocument toDocument() {
        TeamDocument teamDocument = new TeamDocument();
        teamDocument.setTeamId(this.teamId);
        teamDocument.setName(this.name);
        teamDocument.setComment(this.comment);
        teamDocument.setColor(this.color);
        teamDocument.setLogo(this.logo);
        return teamDocument;
    }

    public TeamRes toTeamRes() {
        TeamRes teamRes = new TeamRes();
        teamRes.setTeamId(this.teamId);
        teamRes.setName(this.name);
        teamRes.setComment(this.comment);
        teamRes.setColor(this.color);
        teamRes.setLogo(this.logo);
        return teamRes;

    }
}

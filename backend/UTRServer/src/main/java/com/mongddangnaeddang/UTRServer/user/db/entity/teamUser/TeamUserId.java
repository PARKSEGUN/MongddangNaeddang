package com.mongddangnaeddang.UTRServer.user.db.entity.teamUser;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TeamUserId implements Serializable {
    private String authUuid;
    private Integer teamId;
}
package com.mongddangnaeddang.UTRServer.user.db.entity.teamUser;


import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@IdClass(TeamUserId.class)
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class TeamUser {
    private Timestamp joinAt;

    @Id
    private String authUuid;

    @Id
    private Integer teamId;
}

package com.mongddangnaeddang.UTRServer.user.db.repository;

import com.mongddangnaeddang.UTRServer.user.db.entity.teamUser.TeamUser;
import com.mongddangnaeddang.UTRServer.user.db.entity.teamUser.TeamUserId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TeamUserRepository extends JpaRepository<TeamUser, TeamUserId> {
    Optional<TeamUser> findByAuthUuidAndTeamId(String authUuid, int teamId);
}

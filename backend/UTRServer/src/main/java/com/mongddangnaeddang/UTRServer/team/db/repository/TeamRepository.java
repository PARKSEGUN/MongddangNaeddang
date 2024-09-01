package com.mongddangnaeddang.UTRServer.team.db.repository;

import com.mongddangnaeddang.UTRServer.team.db.entity.Team;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface TeamRepository extends JpaRepository<Team, Integer> {

    int findTeamIdByName(String name);

    Optional<Team> findByName(String name);
}

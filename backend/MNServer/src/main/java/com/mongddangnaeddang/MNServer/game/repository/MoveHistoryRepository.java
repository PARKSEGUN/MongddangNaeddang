package com.mongddangnaeddang.MNServer.game.repository;

import com.mongddangnaeddang.MNServer.game.entity.MoveHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public interface MoveHistoryRepository extends JpaRepository<MoveHistory, Integer> {
    List<MoveHistory> findAllByAuthUuid(String authUuid);

    @Query("SELECT COALESCE(SUM(m.distance), 0) FROM MoveHistory m WHERE m.endTime > :since and m.authUuid = :authUuid")
    Double findTotalDistanceByAuthUuidAndSince(@Param("authUuid") String authUuid,@Param("since") LocalDateTime since);
}

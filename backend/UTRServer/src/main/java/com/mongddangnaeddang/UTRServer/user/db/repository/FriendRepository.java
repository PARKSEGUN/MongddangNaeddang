package com.mongddangnaeddang.UTRServer.user.db.repository;

import com.mongddangnaeddang.UTRServer.user.db.entity.Friend;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FriendRepository extends JpaRepository<Friend, Integer> {
    List<Friend> findByUser1Uuid(String authUuid);
    List<Friend> findByUser2Uuid(String authUuid);

    @Transactional
    void deleteByUser1UuidAndUser2Uuid(String friendId, String authUuid);
}

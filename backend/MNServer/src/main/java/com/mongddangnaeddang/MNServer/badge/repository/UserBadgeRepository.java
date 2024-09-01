package com.mongddangnaeddang.MNServer.badge.repository;

import com.mongddangnaeddang.MNServer.badge.entity.UserBadge;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserBadgeRepository extends JpaRepository<UserBadge, Integer> {
    List<UserBadge> findAllByAuthUuid(String authUuid);
    boolean existsByIdAndAuthUuid(int id, String authUuid);
}

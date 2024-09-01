package com.mongddangnaeddang.MNServer.badge.repository;

import com.mongddangnaeddang.MNServer.badge.entity.Badge;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BadgeRepository extends JpaRepository<Badge, Integer> {
    Optional<Badge> findById(int id);
}

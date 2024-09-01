package com.mongddangnaeddang.MNServer.badge.service;

import com.mongddangnaeddang.MNServer.badge.dto.request.UserBadgeRequestDTO;
import com.mongddangnaeddang.MNServer.badge.dto.response.BadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.dto.response.UserBadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.entity.Badge;

import java.util.List;

public interface BadgeService {
    public List<UserBadgeResponseDTO> getUserBadge(String profileUUID);

    // badge
    public List<BadgeResponseDTO> getAllBadges();

    // userBadge
    public UserBadgeResponseDTO createUserBadge(UserBadgeRequestDTO userBadgeRequestDTO);
}

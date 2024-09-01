package com.mongddangnaeddang.MNServer.badge.service;

import com.mongddangnaeddang.MNServer.badge.dto.request.UserBadgeRequestDTO;
import com.mongddangnaeddang.MNServer.badge.dto.response.BadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.dto.response.UserBadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.entity.Badge;
import com.mongddangnaeddang.MNServer.badge.entity.UserBadge;
import com.mongddangnaeddang.MNServer.badge.repository.BadgeRepository;
import com.mongddangnaeddang.MNServer.badge.repository.UserBadgeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class BadgeServiceImpl implements BadgeService {

    private final UserBadgeRepository userBadgeRepository;
    private final BadgeRepository badgeRepository;

    @Override
    public List<UserBadgeResponseDTO> getUserBadge(String authUuid) {
        List<UserBadge> userBadges = userBadgeRepository.findAllByAuthUuid(authUuid);
        List<UserBadgeResponseDTO> userBadgeResponseDTOs = new ArrayList<>();
        for(UserBadge userBadge : userBadges){
            userBadgeResponseDTOs.add(convertToDTO(userBadge));
        }
        return userBadgeResponseDTOs;
    }

    @Override
    public List<BadgeResponseDTO> getAllBadges() {
        List<BadgeResponseDTO> badges = new ArrayList<>();
        List<Badge> badgeList = badgeRepository.findAll();
        for(Badge badge : badgeList){
            badges.add(convertToBadgeDTO(badge));
        }
        return badges;
    }

    @Override
    public UserBadgeResponseDTO createUserBadge(UserBadgeRequestDTO userBadgeRequestDTO) {
        Badge badge = badgeRepository.findById(userBadgeRequestDTO.getBadgeId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 뱃지 ID입니다."));

        UserBadge userBadge = convertToEntity(userBadgeRequestDTO);
        badge.addUserBadge(userBadge);

        return convertToDTO(userBadge);
    }

    UserBadgeResponseDTO convertToDTO(UserBadge userBadge) {
        return UserBadgeResponseDTO.builder()
                .authUuid(userBadge.getAuthUuid())
                .createdTime(userBadge.getCreatedTime())
                .badgeId(userBadge.getBadge().getId())
                .name(userBadge.getBadge().getName())
                .build();
    }

    private UserBadge convertToEntity(UserBadgeRequestDTO userBadgeRequestDTO) {
        Badge badge = badgeRepository.findById(userBadgeRequestDTO.getBadgeId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 뱃지 ID입니다."));

        return UserBadge.builder()
                .authUuid(userBadgeRequestDTO.getAuthUuid())
                .badge(badge)
                .createdTime(LocalDateTime.now())
                .build();
    }

    BadgeResponseDTO convertToBadgeDTO(Badge badge) {
        return BadgeResponseDTO.builder()
                .id(badge.getId())
                .name(badge.getName())
                .condition(badge.getCondition())
                .build();
    }
}

package com.mongddangnaeddang.MNServer.badge.controller;

import com.mongddangnaeddang.MNServer.badge.dto.response.BadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.dto.response.UserBadgeResponseDTO;
import com.mongddangnaeddang.MNServer.badge.entity.Badge;
import com.mongddangnaeddang.MNServer.badge.service.BadgeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/badge")
@RequiredArgsConstructor
@Tag(name = "Badge API", description = " 뱃지 ")
public class BadgeController {

    private final BadgeService badgeService;

    // - 유저 획득 뱃지 조회
    @GetMapping("/mybadge/{profileUUID}")
    @Operation(summary = "유저 획득 뱃지 조회", description = "특정 유저가 보유한 뱃지 조회")
    public ResponseEntity<?> getUserBadge(@PathVariable("profileUUID") String profileUUID){
        List<UserBadgeResponseDTO> UserBadgeResponseDTOs = badgeService.getUserBadge(profileUUID);
        return new ResponseEntity<>(UserBadgeResponseDTOs, HttpStatus.OK);
    }

    // - 유저 획득 뱃지 조회
    @GetMapping("/all")
    @Operation(summary = "전체 뱃지 조회", description = "전체 뱃지 조회")
    public ResponseEntity<?> getAllBadges(){
        List<BadgeResponseDTO> badges = badgeService.getAllBadges();
        return new ResponseEntity<>(badges, HttpStatus.OK);
    }
    
}

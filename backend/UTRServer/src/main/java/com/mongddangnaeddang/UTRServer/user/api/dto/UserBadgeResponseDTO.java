package com.mongddangnaeddang.UTRServer.user.api.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserBadgeResponseDTO {
    private String authUuid;
    private LocalDateTime createdTime;
    private int badgeId;
    private String name;
}

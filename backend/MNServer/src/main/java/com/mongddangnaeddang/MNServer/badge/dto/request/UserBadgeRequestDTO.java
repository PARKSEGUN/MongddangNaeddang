package com.mongddangnaeddang.MNServer.badge.dto.request;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserBadgeRequestDTO {
    private String authUuid;
    private int badgeId;
}

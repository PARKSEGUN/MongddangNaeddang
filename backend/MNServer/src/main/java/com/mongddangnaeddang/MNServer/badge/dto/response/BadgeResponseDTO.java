package com.mongddangnaeddang.MNServer.badge.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BadgeResponseDTO {
    private int id;
    private String name;
    private int condition;
}

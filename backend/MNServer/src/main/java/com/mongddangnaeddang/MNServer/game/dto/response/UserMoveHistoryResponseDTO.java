package com.mongddangnaeddang.MNServer.game.dto.response;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserMoveHistoryResponseDTO {
    private Double distance;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
}

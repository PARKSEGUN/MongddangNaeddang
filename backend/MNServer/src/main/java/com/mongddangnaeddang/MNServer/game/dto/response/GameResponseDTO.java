package com.mongddangnaeddang.MNServer.game.dto.response;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameResponseDTO {
    private int id;
    private String authUuid;
    private double distance;
    private double area;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Set<String> stolenTeamNames;
}

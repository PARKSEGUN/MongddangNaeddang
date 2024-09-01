package com.mongddangnaeddang.MNServer.game.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GameRequestDTO {
    private String authUuid;
    private List<List<Double>> multipoints;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
}

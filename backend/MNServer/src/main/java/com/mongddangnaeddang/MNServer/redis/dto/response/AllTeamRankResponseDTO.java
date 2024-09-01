package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AllTeamRankResponseDTO {
    private String teamId;
    private double unit;
    private long rank;
}

package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamRankResponseDTO {
    private String teamId;
    private double areaSum;
    private long areaRank;
    private double distanceSum;
    private long distanceRank;
}

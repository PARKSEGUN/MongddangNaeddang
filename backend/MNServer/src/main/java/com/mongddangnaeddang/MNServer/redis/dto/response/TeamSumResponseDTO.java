package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamSumResponseDTO {
    private String teamId;
    private String areaSum;
    private String distanceSum;
}

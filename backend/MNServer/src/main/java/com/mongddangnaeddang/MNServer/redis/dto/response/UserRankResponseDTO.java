package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRankResponseDTO {
    private String authUuid;
    private double unit;
    private long rank;
}

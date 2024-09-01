package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDTO {
    private String authUuid;
    private String distanceSum;
}

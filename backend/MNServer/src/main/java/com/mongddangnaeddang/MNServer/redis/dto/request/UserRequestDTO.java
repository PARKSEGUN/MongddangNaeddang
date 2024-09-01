package com.mongddangnaeddang.MNServer.redis.dto.request;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRequestDTO {
    private String authUuid;
    private Double distance;
}

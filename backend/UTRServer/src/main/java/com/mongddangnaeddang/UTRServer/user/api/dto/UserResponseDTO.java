package com.mongddangnaeddang.UTRServer.user.api.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDTO { // redis client 에서 distanceSum 받아오기 위한 dto
    private String authUuid;
    private String distanceSum;
}

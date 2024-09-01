package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamDetailResponseDTO {
    private int teamId;
    private String name;
    private String comment;
    private String color;
    private String logo;
}

package com.mongddangnaeddang.MNServer.redis.dto.request;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamRequestDTO {
    private String id;
    private Double area;
    private Double distance;
    private String polygon;
}

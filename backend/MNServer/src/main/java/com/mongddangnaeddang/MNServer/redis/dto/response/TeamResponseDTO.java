package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamResponseDTO {
    private String teamId;
    private String areaSum;
    private String distanceSum;
    private List<String> polygons;
}

package com.mongddangnaeddang.MNServer.redis.dto;

import lombok.*;
import org.locationtech.jts.geom.Polygon;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PolygonDTO {
    private String teamId;
    private Polygon Polygon;
}

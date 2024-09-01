package com.mongddangnaeddang.MNServer.redis.dto.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MapResponseDTO {
    private String id;
    private String teamId;
    private String name;
    private String color;
    private String logo;
    List<List<List<Double>>> area;
}

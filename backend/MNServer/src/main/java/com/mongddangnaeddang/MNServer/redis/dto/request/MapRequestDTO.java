package com.mongddangnaeddang.MNServer.redis.dto.request;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MapRequestDTO {
    private List<Double> leftTop;
    private List<Double> rightTop;
    private List<Double> leftBottom;
    private List<Double> rightBottom;
}

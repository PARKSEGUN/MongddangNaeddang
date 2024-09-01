package com.mongddangnaeddang.MNServer.game.entity;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Polygon;

import java.time.LocalDateTime;

@Entity
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MoveHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="move_history_id")
    private int id;

    private String authUuid;

    @Column(columnDefinition = "GEOMETRY")
    private Polygon area;

    private double distance;

    private LocalDateTime startTime;

    private LocalDateTime endTime;
}

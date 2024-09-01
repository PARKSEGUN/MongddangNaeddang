package com.mongddangnaeddang.MNServer.game.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BackupMap {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="map_id")
    private int id;

    private int teamId;

    private double areaSum;

    private double distanceSum;

    private LocalDateTime createdTime;
}

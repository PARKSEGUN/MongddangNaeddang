package com.mongddangnaeddang.MNServer.badge.entity;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Polygon;

import java.time.LocalDateTime;

@Entity
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserBadge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="user_badge_id")
    private int id;

    private String authUuid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="badge_id")
    private Badge badge;

    private LocalDateTime createdTime;
}

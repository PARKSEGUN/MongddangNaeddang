package com.mongddangnaeddang.UTRServer.user.db.entity;

import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Friend {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // auto increment
    @Column(name = "friend_id")
    private int friend_id;

    @Column(name = "user1_uuid")
    private String user1Uuid;

    @Column(name = "user2_uuid")
    private String user2Uuid;

    @Column(name = "created_at")
    private Timestamp createdAt;
}

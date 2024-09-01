package com.mongddangnaeddang.MNServer.notification.entity;


import jakarta.persistence.*;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;

import java.sql.Timestamp;

@Data
@Entity
@Table(name = "team_notification", schema = "myground")
public class TeamNotification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id", nullable = false)
    private Integer notificationId;

    @Column(name = "title", length = 255)
    private String title;

    @Column(name = "content", length = 255)
    private String content;

    @Column(name = "created_time")
    private Timestamp createdTime;

    @Column(name = "team1_id", nullable = false, length = 255)
    private int team1Id;

    @Column(name = "team2_id", nullable = false, length = 255)
    private int team2Id;

    @Column(name = "team1_name", nullable = false, length = 255)
    private String team1Name;

    @Column(name = "team2_name", nullable = false, length = 255)
    private String team2Name;


}
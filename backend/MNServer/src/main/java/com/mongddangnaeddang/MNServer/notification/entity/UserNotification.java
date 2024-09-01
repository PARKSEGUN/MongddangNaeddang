package com.mongddangnaeddang.MNServer.notification.entity;


import jakarta.persistence.*;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;

import java.sql.Timestamp;

@Data
@Entity
@Table(name = "user_notification", schema = "myground")
public class UserNotification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id", nullable = false)
    private Integer notificationId;

    @Column(name = "title", length = 255)
    private String title;

    @Column(name = "content", length = 255)
    private String content;

    @CreatedDate
    @Column(name = "created_time")
    private Timestamp createdTime;

    @Column(name = "user1_uuid", nullable = false, length = 255)
    private String user1Uuid;

    @Column(name = "user2_uuid", nullable = false, length = 255)
    private String user2Uuid;

    @Column(name = "user1_nickname", nullable = false, length = 255)
    private String user1Name;

    @Column(name = "user2_nickname", nullable = false, length = 255)
    private String user2Name;


}
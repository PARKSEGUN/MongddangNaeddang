package com.mongddangnaeddang.MNServer.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotifData {
    private String user1Uuid;
    private String user2Uuid;
    private String user1Name;
    private String user2Name;
    private int teamId;
    private String teamName;
    private String title;
    private String content;
    private String createdAt;

    }

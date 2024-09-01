package com.mongddangnaeddang.MNServer.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class GroupNotification {
    private String title;
    private String content;
    private String userUuid;
    private String userName;
    private String token;
}

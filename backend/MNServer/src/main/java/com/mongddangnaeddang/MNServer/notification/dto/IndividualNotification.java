package com.mongddangnaeddang.MNServer.notification.dto;

import lombok.Data;

import java.util.Map;

@Data
public class IndividualNotification {
    private String title;
    private String content;
    private String sender;
    private String senderUuid;
    private String receiver;
    private String receiverUuid;
    private String token;
}

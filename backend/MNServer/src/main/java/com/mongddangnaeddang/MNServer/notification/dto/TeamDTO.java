package com.mongddangnaeddang.MNServer.notification.dto;

import lombok.Data;

@Data
public class TeamDTO {
    private String auth1Uuid; // 유저 고유 아이디
    private String auth2Uuid; // 유저 고유 아이디
    private String auth1Name;
    private String auth2Name;
    private String teamName; // 구독 ID
    private String auth1Token; // user Token Id << 구독시키기.
    private String auth2Token; // user Token Id << 구독시키기.
}

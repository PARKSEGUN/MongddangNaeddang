package com.mongddangnaeddang.MNServer.notification.dto;

import lombok.Data;

@Data
public class TestDTO {
    private String teamId; // token id
    private String title; // 알람 헤더
    private String content; // 본문
}

package com.mongddangnaeddang.UTRServer.user.api.dto.request;

import lombok.Data;

/*
    친구 수락 알람을 request 하는데 사용하는 DTO입니다.

 */
@Data
public class AlarmRequestDto {
    private String sender; // 친구 요청 받은 사람 nicknmae
    private String senderUuid;
    private String receiver; // 친구 요청 한 사람 nickname
    private String receiverUuid;
    private String token; // 친구 요청 한 사람 fcm 토큰

}

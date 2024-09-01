package com.mongddangnaeddang.UTRServer.user.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Schema(name = "UserTeamleaderResponseDto", description = "/user/teamleader 요청에 대한 응답. 팀장 정보")
public class UserTeamleaderResponseDto {
    String authUuid;
    String fcmToken;
}
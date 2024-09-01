package com.mongddangnaeddang.UTRServer.auth.api.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(name = "AuthAutoLoginDto", description = "auth controller 에 자동로그인 요청 시 사용되는 dto")
public class AuthAutoLoginDto {
    @Schema(name = "authUuid")
    String authUuid;
    @Schema(name = "fcmToken")
    String fcmToken;
}

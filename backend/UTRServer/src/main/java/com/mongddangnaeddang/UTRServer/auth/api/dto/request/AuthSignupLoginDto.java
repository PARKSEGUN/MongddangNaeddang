package com.mongddangnaeddang.UTRServer.auth.api.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(name = "AuthSignupLoginDto", description = "auth controller 에 회원가입, 로그인 요청 시 사용되는 dto")
public class AuthSignupLoginDto {
    @Schema(name = "vendor", example = "kakao/naver/google")
    String vendor;
    @Schema(name = "fcmToken")
    String fcmToken;
    @Schema(name = "rawId")
    String rawId;
    @Schema(name = "defaultNickname")
    String defaultNickname;
}

package com.mongddangnaeddang.UTRServer.auth.api.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(name = "AuthDeleteLogoutDto", description = "auth controller 에 탈퇴, 로그아웃 요청 시 사용되는 dto")
public class AuthDeleteLogoutDto {
    @Schema(name="vendor", example="kakao/naver/google")
    String vendor;

    @Schema(name="authUuid", example="kakao_@@@@/naver_@@@@/google_@@@@")
    String authUuid;
}

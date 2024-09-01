package com.mongddangnaeddang.UTRServer.auth.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(name = "AuthResponseDto", description = "auth controller 에서 응답 시 사용되는 dto")
public class AuthResponseDto {
    @Schema(name="authUuid", example="kakao_@@@@/naver_@@@@/google_@@@@")
    String authUuid;
    @Schema(name="token", example="AAAAAAA.BBBBBBB.CCCCCCC")
    String token;
}

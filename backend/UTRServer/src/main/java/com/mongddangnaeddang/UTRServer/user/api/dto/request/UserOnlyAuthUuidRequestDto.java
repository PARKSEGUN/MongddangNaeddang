package com.mongddangnaeddang.UTRServer.user.api.dto.request;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@Setter
@Schema(name = "UserRequestDto", description = "user controller 에 내 정보(/profile), 내 팀 id(/myteam), 내 뱃지 정보(/badge), 친구 리스트(/detail) 요청 시 사용되는 dto")
public class UserOnlyAuthUuidRequestDto {
    @Schema(name="authUuid", example="kakao_@@@@/naver_@@@@/google_@@@@")
    String authUuid;
}

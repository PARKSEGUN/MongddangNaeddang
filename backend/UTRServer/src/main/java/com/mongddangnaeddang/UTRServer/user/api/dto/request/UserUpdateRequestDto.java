package com.mongddangnaeddang.UTRServer.user.api.dto.request;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@Setter
@Schema(name = "UserRequestDto", description = "user controller 에 요청 시 사용되는 dto")
public class UserUpdateRequestDto {
    @Schema(name="authUuid", example="kakao_@@@@/naver_@@@@/google_@@@@")
    String authUuid;
    @Schema(name="nickname", example="new_nick_name")
    String nickname;
    @Schema(name="address", example="new_address")
    String address;
    @Schema(name="comment", example="new_comment")
    String comment;
}

package com.mongddangnaeddang.UTRServer.user.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Schema(name = "UserMyTeamIdResponseDto", description = "/user/myteam 요청에 대한 응답. 내 팀id 정보")
public class UserMyTeamIdResponseDto {
    int teamId;
}
package com.mongddangnaeddang.UTRServer.user.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.LinkedList;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Schema(name = "UserInfo", description = "/user/profile 요청에 대한 응답. user_profile, move_history 가공.")
public class UserInfo {
    String nickname;
    String address;
}
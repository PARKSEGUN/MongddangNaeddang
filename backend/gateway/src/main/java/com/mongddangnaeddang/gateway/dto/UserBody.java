package com.mongddangnaeddang.gateway.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserBody {
    String vendor;
    String fcmToken;
    String rawId;
    String defaultNickname;
}

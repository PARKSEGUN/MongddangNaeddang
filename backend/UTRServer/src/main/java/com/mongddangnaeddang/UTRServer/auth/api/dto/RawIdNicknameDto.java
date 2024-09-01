package com.mongddangnaeddang.UTRServer.auth.api.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@Setter
@ToString
public class RawIdNicknameDto {
    private String rawId;
    private String nickname;
}

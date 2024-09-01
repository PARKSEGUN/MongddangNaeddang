package com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@Schema
@AllArgsConstructor
@NoArgsConstructor
public class UserContributionFeignReq {
    @Schema(name = "authUuid", example = "asdf1234")
    private String authUuid;
    @Schema(name = "joinAt", example = "1111122222")
    private Timestamp joinAt;
}

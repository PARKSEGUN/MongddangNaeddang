package com.mongddangnaeddang.UTRServer.team.api.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema
@Data
public class UserRes {
    @Schema(name = "authUuid", example = "qkrtprjs1234")
    String authUuid;
    @Schema(name = "teamId", example = "5")
    int teamId;
    @Schema(name = "nickname", example = "qkrtprjs")

    String nickname;
    @Schema(name = "comment", example = "좋은 사람입니다")

    String comment;

    @Schema(name = "isLeader", example = "false")

    boolean isLeader;

    @Schema(name = "userImage", example = "C:\\Users\\SSAFY\\Desktop\\upload\\kakao_3634068227_myImage.png")
    String userImage;

    @Schema(name = "distance", example = "123.41234")
    double distance;
    @Schema(name = "fcmToken", example = "asdfasfs")
    String fcmToken;
}

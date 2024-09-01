package com.mongddangnaeddang.MNServer.game.dto.response;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TeamUserResponseDTO {
    private String authUuid;
    private int teamId;
    private String nickname;
    private String comment;
    private boolean isLeader;
    private String userImage;
    private double distance;
    private String fcmToken;
}

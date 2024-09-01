package com.mongddangnaeddang.UTRServer.auth.db.entity;

import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class UserProfile {
    @Id
    @Column(name = "auth_uuid")
    String authUuid;
    @Column(name = "nickname")
    String nickname;
    @Column(name = "comment")
    String comment;
    @Column(name = "is_leader", columnDefinition = "TINYINT(1)")
    Boolean isLeader;
    @Column(name = "image_address")
    String imageAddress;
    @Column(name = "fcm_token")
    String fcmToken;
    @Column(name = "team_id")
    int teamId;
    @Column(name = "address")
    String address;

    public UserRes toUserRes() {

        UserRes userRes = new UserRes();
        userRes.setLeader(isLeader);
        userRes.setTeamId(teamId);
        userRes.setAuthUuid(authUuid);
        userRes.setComment(comment);
        userRes.setNickname(nickname);
        userRes.setUserImage(imageAddress);
        userRes.setFcmToken(fcmToken);
        return userRes;
    }
}

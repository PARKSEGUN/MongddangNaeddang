package com.mongddangnaeddang.UTRServer.team.api.dto.request;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Schema
@ToString
public class AlarmToUserReq {
    private String auth1Uuid;
    private String auth2Uuid;
    private String auth1Name;
    private String auth2Name;
    private String auth1Token;
    private String auth2Token;
    private String teamName;

    public static AlarmToUserReq of(UserProfile leader, UserProfile member, String teamName) {
        AlarmToUserReq alarmToUserReq = new AlarmToUserReq();
        alarmToUserReq.setAuth1Uuid(leader.getAuthUuid());
        alarmToUserReq.setAuth2Uuid(member.getAuthUuid());
        alarmToUserReq.setAuth1Token(leader.getFcmToken());
        alarmToUserReq.setAuth2Token(member.getFcmToken());
        alarmToUserReq.setTeamName(teamName);
        alarmToUserReq.setAuth1Name(leader.getNickname());
        alarmToUserReq.setAuth2Name(member.getNickname());
        return alarmToUserReq;
    }
}

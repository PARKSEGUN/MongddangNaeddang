package com.mongddangnaeddang.UTRServer.user.api.service;

import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserBadgeResponseDTO;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserMoveHistoryResponseDTO;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.UserOnlyAuthUuidRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.UserUpdateRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.response.*;

import java.util.List;

public interface UserService {
    UserProfileResponseDto getUserProfile(String authUuid);
    void updateUserInfo(UserUpdateRequestDto userUpdateRequestDto);
    void updateProfileImage(String authUuid, String path);
    boolean isExistNickname(String nickname);
    UserAlarmResponse getUserFcmTokenAndAuthUuid(String nickName);
    String getUserTeamId(String authUuid);
    UserTeamleaderResponseDto getTeamLeader(String teamId);
    UserMyTeamIdResponseDto getMyTeamId(UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto);
    List<UserMoveHistoryResponseDTO> getMyHistory(UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto);
    List<UserBadgeResponseDTO> getMyBadge(UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto);

    UserAlarmNickNameResponse getUserFcmTokenAndNickName(String authUuid);

    boolean notMyNickname(String authUuid, String nickname);
    List<UserRes> getUsersByTeamId(int teamId);
}

package com.mongddangnaeddang.UTRServer.auth.api.service;

import com.mongddangnaeddang.UTRServer.auth.api.dto.RawIdNicknameDto;
import com.mongddangnaeddang.UTRServer.auth.db.entity.UserAuth;
import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;

public interface AuthService {
    public boolean checkUserExists (String authUuid);

    RawIdNicknameDto getUserInfoFromVendor(String accessToken, String vendor);

    void addNewUserAuth(UserAuth userAuth);

    void addNewUserProfile(UserProfile userProfile);

    void deleteCurrentUserProfile(String authUuid);

    void deleteCurrentUserAuth(String authUuid);

    void updateToken(String authUuid, String token, String fcmToken);

    void deleteToken(String authUuid);

    boolean checkAccessTokenOwnership(String authUuid, String accessToken);

    void updateFcmToken(String authUuid, String fcmToken);
}

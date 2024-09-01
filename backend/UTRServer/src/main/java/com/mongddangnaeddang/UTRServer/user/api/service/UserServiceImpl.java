package com.mongddangnaeddang.UTRServer.user.api.service;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.auth.db.repository.UserProfileRepository;
import com.mongddangnaeddang.UTRServer.client.team.MNServerClient;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.request.UserContributionFeignReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserBadgeResponseDTO;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserMoveHistoryResponseDTO;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.UserOnlyAuthUuidRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.UserUpdateRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.response.*;
import com.mongddangnaeddang.UTRServer.user.db.entity.teamUser.TeamUser;
import com.mongddangnaeddang.UTRServer.user.db.entity.teamUser.TeamUserId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserProfileRepository userProfileRepository;
    @Autowired
    private MNServerClient mnServerClient;

    @Override
    public UserProfileResponseDto getUserProfile(String authUuid) {
        // user_profile 추출
        UserProfile userProfile = userProfileRepository.findByAuthUuid(authUuid);

        // 가공
        UserProfileResponseDto userProfileResponseDto = new UserProfileResponseDto();
        userProfileResponseDto.setNickname(userProfile.getNickname());
        userProfileResponseDto.setAddress(userProfile.getAddress());
        userProfileResponseDto.setProfileImage(userProfile.getImageAddress());
        userProfileResponseDto.setComment(userProfile.getComment());
        return userProfileResponseDto;
    }

    @Override
    public void updateUserInfo(UserUpdateRequestDto userUpdateRequestDto) {
        UserProfile up = userProfileRepository.findByAuthUuid(userUpdateRequestDto.getAuthUuid());
        up.setNickname(userUpdateRequestDto.getNickname().trim());
        up.setComment(userUpdateRequestDto.getComment());
        up.setAddress(userUpdateRequestDto.getAddress());
        userProfileRepository.save(up);

    }

    @Override
    public void updateProfileImage(String authUuid, String path) {
        UserProfile userProfile = userProfileRepository.findByAuthUuid(authUuid);
        userProfile.setImageAddress(path);
        userProfileRepository.save(userProfile);
    }

    @Override
    public boolean isExistNickname(String nickname) {
        return userProfileRepository.existsByNickname(nickname);
    }

    @Override
    public UserAlarmResponse getUserFcmTokenAndAuthUuid(String nickName) {
        UserProfile userProfile = userProfileRepository.findByNickname(nickName);
        UserAlarmResponse userAlarmResponse = new UserAlarmResponse();
        userAlarmResponse.setAuthUuid(userProfile.getAuthUuid());
        userAlarmResponse.setToken(userProfile.getFcmToken());
        return userAlarmResponse;
    }

    @Override
    public String getUserTeamId(String authUuid) {
        UserProfile userProfile = userProfileRepository.findByAuthUuid(authUuid);
        int tid = userProfile.getTeamId();
        return Integer.toString(tid);
    }

    @Override
    public UserTeamleaderResponseDto getTeamLeader(String teamId) {
        int tid = Integer.parseInt(teamId);
        UserProfile userProfile = userProfileRepository.findByTeamIdAndIsLeader(tid, true).orElseThrow();
        UserTeamleaderResponseDto userTeamleaderResponseDto = new UserTeamleaderResponseDto();
        userTeamleaderResponseDto.setAuthUuid(userProfile.getAuthUuid());
        userTeamleaderResponseDto.setFcmToken(userProfile.getFcmToken());
        return userTeamleaderResponseDto;
    }

    @Override
    public UserMyTeamIdResponseDto getMyTeamId(UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        UserProfile userProfile = userProfileRepository.findByAuthUuid(userOnlyAuthUuidRequestDto.getAuthUuid());
        return new UserMyTeamIdResponseDto(userProfile.getTeamId());
    }

    @Override
    public List<UserMoveHistoryResponseDTO> getMyHistory(UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        List<UserMoveHistoryResponseDTO> list = null;
        try {
            ResponseEntity<?> response = mnServerClient.getMyHistory(userOnlyAuthUuidRequestDto.getAuthUuid());
            list = (List<UserMoveHistoryResponseDTO>) response.getBody();
            System.out.println(response.getBody());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<UserBadgeResponseDTO> getMyBadge(UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        List<UserBadgeResponseDTO> list = null;
        try {
            ResponseEntity<?> response = mnServerClient.getMyBadge(userOnlyAuthUuidRequestDto.getAuthUuid());
            list = (List<UserBadgeResponseDTO>) response.getBody();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public UserAlarmNickNameResponse getUserFcmTokenAndNickName(String authUuid) {
        UserProfile userProfile = userProfileRepository.findByAuthUuid(authUuid);
        UserAlarmNickNameResponse userAlarmResponse = new UserAlarmNickNameResponse();
        userAlarmResponse.setNickName(userProfile.getNickname());
        userAlarmResponse.setToken(userProfile.getFcmToken());
        return userAlarmResponse;
    }

    @Override
    public boolean notMyNickname(String authUuid, String nickname) {
        UserProfile userProfile = userProfileRepository.findByAuthUuid(authUuid);
        return !userProfile.getNickname().equals(nickname);
    }

    @Override
    public List<UserRes> getUsersByTeamId(int teamId) {
        List<UserProfile> usersResult = userProfileRepository.findByTeamId(teamId);
        List<UserRes> userResList = new ArrayList<>();
        for (UserProfile userProfile : usersResult) {
            UserRes userRes = userProfile.toUserRes();
            userResList.add(userRes);
        }
        return userResList;
    }
}

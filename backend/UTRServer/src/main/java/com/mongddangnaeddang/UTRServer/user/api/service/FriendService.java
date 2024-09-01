package com.mongddangnaeddang.UTRServer.user.api.service;

import com.mongddangnaeddang.UTRServer.user.api.dto.response.FriendListResponseDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.FriendReqDelRequestDto;

import java.util.List;

public interface FriendService {

    List<FriendListResponseDto> getMyFriendList(String authUuid);

    void becomeFriends(FriendReqDelRequestDto friendReqDelRequestDto);

    boolean deleteFriend(FriendReqDelRequestDto friendReqDelRequestDto);

    FriendListResponseDto searchUser(String nickname);
}

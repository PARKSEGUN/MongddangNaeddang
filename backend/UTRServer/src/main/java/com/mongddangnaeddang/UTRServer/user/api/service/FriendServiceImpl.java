package com.mongddangnaeddang.UTRServer.user.api.service;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.auth.db.repository.UserProfileRepository;
import com.mongddangnaeddang.UTRServer.client.team.MNServerClient;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.AlarmRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.response.FriendListResponseDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.FriendReqDelRequestDto;
import com.mongddangnaeddang.UTRServer.user.db.entity.Friend;
import com.mongddangnaeddang.UTRServer.user.db.repository.FriendRepository;
import feign.FeignException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

@Service
public class FriendServiceImpl implements FriendService {
    @Autowired
    private FriendRepository friendRepository;
    @Autowired
    private UserProfileRepository userProfileRepository;
    @Autowired
    private MNServerClient mnServerClient;

    @Override
    public List<FriendListResponseDto> getMyFriendList(String authUuid) {


        // 친구 목록 가져오기
        List<Friend> list1 = friendRepository.findByUser1Uuid(authUuid);
        List<Friend> list2 = friendRepository.findByUser2Uuid(authUuid);

        // 친구 리스트 돌아가면서 데이터 받아오기
        int size1 = list1.size();
        int size2 = list2.size();
        List<FriendListResponseDto> list = new ArrayList<>();


        // TODO : redis 서버에 total_distance 요청해서 받아와야 한다.
        UserProfile up = null;
        for (Friend friend : list1) {
            up = userProfileRepository.findByAuthUuid(friend.getUser2Uuid());
            double dist = 0.0;
            try {
                ResponseEntity<?> response = mnServerClient.getDistanceSum(up.getAuthUuid());
                LinkedHashMap<String, String> map = (LinkedHashMap<String, String>) response.getBody();
                dist = Double.parseDouble(map.get("distanceSum"));
            } catch(FeignException e) {
                System.out.println("누적거리 데이터 없음");
            }
            list.add(new FriendListResponseDto(up.getNickname(), up.getImageAddress(), dist, up.getComment()));
        }
        for (Friend friend : list2) {
            up = userProfileRepository.findByAuthUuid(friend.getUser1Uuid());
            double dist = 0.0;
            try {
                ResponseEntity<?> response = mnServerClient.getDistanceSum(up.getAuthUuid());
                LinkedHashMap<String, String> map = (LinkedHashMap<String, String>) response.getBody();
                dist = Double.parseDouble(map.get("distanceSum"));
            } catch(FeignException e) {
                System.out.println("누적거리 데이터 없음");
            }
            list.add(new FriendListResponseDto(up.getNickname(), up.getImageAddress(), dist, up.getComment()));
        }

        // 리스트 리턴
        return list;
    }

    @Override
    public void becomeFriends(FriendReqDelRequestDto friendReqDelRequestDto) {
        Friend fri = new Friend();
        fri.setUser1Uuid(friendReqDelRequestDto.getAuthUuid());
        fri.setUser2Uuid(friendReqDelRequestDto.getFriendId());
        fri.setCreatedAt(new Timestamp(new Date().getTime()));
        friendRepository.save(fri);
        // 수정 1. alarm 보내기
        AlarmRequestDto alarmRequestDto = new AlarmRequestDto();
        // alarmRequestDto Modification
        UserProfile receiver = userProfileRepository.findByAuthUuid(friendReqDelRequestDto.getAuthUuid());

        UserProfile sender = userProfileRepository.findByAuthUuid(friendReqDelRequestDto.getFriendId());

        alarmRequestDto.setSender(receiver.getNickname());// 요청 받은 사람
        alarmRequestDto.setSenderUuid(receiver.getAuthUuid());
        alarmRequestDto.setReceiver(sender.getNickname());  // 요청 한 사람
        alarmRequestDto.setReceiverUuid(sender.getAuthUuid());
        alarmRequestDto.setToken(sender.getFcmToken()); // 알람 요청 한 사람.
        mnServerClient.sendFriendResultAlarm(alarmRequestDto);
    }

    @Transactional
    @Override
    public boolean deleteFriend(FriendReqDelRequestDto friendReqDelRequestDto) {
        try {
            String myAuthUuid = friendReqDelRequestDto.getAuthUuid();
            String friendNickname = friendReqDelRequestDto.getFriendId();
            UserProfile friend = userProfileRepository.findByNickname(friendNickname);
            String friendAuthUuid = friend.getAuthUuid();
            friendRepository.deleteByUser1UuidAndUser2Uuid(friendAuthUuid, myAuthUuid);
            friendRepository.deleteByUser1UuidAndUser2Uuid(myAuthUuid, friendAuthUuid);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public FriendListResponseDto searchUser(String nickname) {
        UserProfile up = userProfileRepository.findByNickname(nickname);
        FriendListResponseDto searchResult = new FriendListResponseDto();
        searchResult.setNickname(up.getNickname());
        searchResult.setProfile_image(up.getImageAddress());
        searchResult.setComment(up.getComment());
        double dist = 0.0;
        try {
//            ResponseEntity<?> response = mnServerClient.getDistanceSum(up.getAuthUuid());
//            LinkedHashMap<String, String> map = (LinkedHashMap<String, String>) response.getBody();
            dist = mnServerClient.getUserDistance(up.getAuthUuid()).getDistanceSum();
            searchResult.setTotal_distance(dist);
        } catch(FeignException e) {
            System.out.println("누적거리 데이터 없음");
        }
        searchResult.setTotal_distance(dist);
        return searchResult;
    }
}

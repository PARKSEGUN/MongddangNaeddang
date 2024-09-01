package com.mongddangnaeddang.UTRServer.user.api.controller;

import com.mongddangnaeddang.UTRServer.common.BaseResponseBody;
import com.mongddangnaeddang.UTRServer.user.api.dto.response.FriendListResponseDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.FriendReqDelRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.FriendSearchDto;
import com.mongddangnaeddang.UTRServer.user.api.service.FriendServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@Tag(name = "Friend", description = "Friend Controller.")
@RestController
@RequestMapping("/api/friend")
public class FriendController {
    @Autowired
    FriendServiceImpl friendService;

    @PostMapping(value = "/list")
    @Operation(summary = "내 친구 리스트 불러오기", description = "authUuid 전달 받으면 해당하는 유저의 친구리스트 응답")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "내 친구 리스트 불러오기 성공."),
            @ApiResponse(responseCode = "400", description = "내 친구 리스트 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> myFriendList(@RequestBody UserRequestDto userRequestDto) {
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return
        List<FriendListResponseDto> list = friendService.getMyFriendList(userRequestDto.getAuthUuid());
        return ResponseEntity.ok().body(list);
    }

    @DeleteMapping(value = "/delete")
    @Operation(summary = "친구 삭제하기", description = "친구 삭제")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "내 친구 삭제 성공."),
            @ApiResponse(responseCode = "400", description = "내 친구 삭제 실패"),
    })
    public ResponseEntity<?> deleteFriend(@RequestBody FriendReqDelRequestDto friendReqDelRequestDto) {
        boolean con = friendService.deleteFriend(friendReqDelRequestDto);
        if(con) {
            return ResponseEntity.ok().body(BaseResponseBody.of("친구 삭제 성공", 200));
        } else {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("친구 삭제 실패", 400));
        }
    }

    @PostMapping(value = "/request")
    @Operation(summary = "친구 요청 수락하기", description = "친구 요청 수락")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "친구 요청 수락 성공."),
            @ApiResponse(responseCode = "400", description = "친구 요청 수락 실패"),
    })
    public ResponseEntity<?> requestToBeFriends(@RequestBody FriendReqDelRequestDto friendReqDelRequestDto) {
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return

        // db 업데이트
        friendService.becomeFriends(friendReqDelRequestDto);
        return ResponseEntity.ok().body(BaseResponseBody.of("친구 성립", 200));
    }

    @PostMapping(value = "/search")
    @Operation(summary = "유저 검색하기", description = "친구 요청 수락")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "친구 검색 성공."),
            @ApiResponse(responseCode = "400", description = "친구 검색 실패."),
    })
    public ResponseEntity<?> searchUser(@RequestBody FriendSearchDto friendSearchDto) {
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return

        if (friendSearchDto.getNickname() == null) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("닉네임을 입력해 주세요.", 400));
        }
        FriendListResponseDto searchResult = friendService.searchUser(friendSearchDto.getNickname().trim());

        return ResponseEntity.ok().body(searchResult);
    }
}

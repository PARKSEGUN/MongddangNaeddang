package com.mongddangnaeddang.UTRServer.user.api.controller;

import com.mongddangnaeddang.UTRServer.common.BaseResponseBody;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserBadgeResponseDTO;
import com.mongddangnaeddang.UTRServer.user.api.dto.UserMoveHistoryResponseDTO;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.UserOnlyAuthUuidRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.UserUpdateRequestDto;
import com.mongddangnaeddang.UTRServer.user.api.dto.response.*;
import com.mongddangnaeddang.UTRServer.user.api.service.UserServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;

@CrossOrigin(origins = "*")
@Tag(name = "User", description = "User Controller.")
@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserServiceImpl userService; // user_profile table 관련 작업

    @PostMapping(value = "/profile")
    @Operation(summary = "내 정보 불러오기", description = "authUuid 전달 받으면 해당하는 유저 정보 응답")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "내 정보 불러오기 성공."),
            @ApiResponse(responseCode = "400", description = "내 정보 불러오기 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> myProfile(@RequestBody UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        // TODO :
        // 세션에
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return
        // profile table 내용 리턴

        UserProfileResponseDto userProfileResponseDto = userService.getUserProfile(userOnlyAuthUuidRequestDto.getAuthUuid());
        return ResponseEntity.ok().body(userProfileResponseDto);
    }

    @PostMapping(value = "/myteam")
    @Operation(summary = "내 팀 정보 불러오기", description = "authUuid 전달 받으면 해당 유저의 팀 id 응답")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "내 팀 id 불러오기 성공."),
            @ApiResponse(responseCode = "400", description = "내 팀 id 불러오기 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> myTeam(@RequestBody UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        // TODO :
        // 세션에
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return
        // profile table 내용 리턴
        UserMyTeamIdResponseDto userMyTeamIdResponseDto = userService.getMyTeamId(userOnlyAuthUuidRequestDto);
        return ResponseEntity.ok().body(userMyTeamIdResponseDto);
    }

    @PostMapping(value = "/history")
    @Operation(summary = "내 기록 불러오기", description = "authUuid 전달 받으면 해당하는 유저 정보 응답")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "내 기록 불러오기 성공."),
            @ApiResponse(responseCode = "400", description = "내 기록 불러오기 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> myHistory(@RequestBody UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        // TODO :
        // 세션에
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return
        // profile table 내용 리턴
        List<UserMoveHistoryResponseDTO> list = userService.getMyHistory(userOnlyAuthUuidRequestDto);
        return ResponseEntity.ok().body(list);
    }

    @PostMapping(value = "/badge")
    @Operation(summary = "내 뱃지 정보 불러오기", description = "authUuid 전달 받으면 해당 유저의 뱃지 상태 리스트 응답")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "내 뱃지 불러오기 성공."),
            @ApiResponse(responseCode = "400", description = "내 뱃지 불러오기 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> myBadge(@RequestBody UserOnlyAuthUuidRequestDto userOnlyAuthUuidRequestDto) {
        // TODO :
        // 세션에
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return
        List<UserBadgeResponseDTO> list = userService.getMyBadge(userOnlyAuthUuidRequestDto);
        // badge 관련 요청 처리
        return ResponseEntity.ok().body(list);
    }

    @PatchMapping(value = "/update")
    @Operation(summary = "내 정보(nickname, comment, address) 수정하기", description = "authUuid, nickname, comment, address 전달받으면 업데이트")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "닉네임 수정 성공."),
            @ApiResponse(responseCode = "400", description = "닉네임 수정 실패 : 로그인 x / 비정상 authUuid / nickname 공백 / nickname 중복"),
    })
    public ResponseEntity<?> updateMyInfo(@RequestBody UserUpdateRequestDto userUpdateRequestDto) {
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return 400

        // 닉네임이 비정상적인 경우 (공백)
        if (userUpdateRequestDto.getNickname() == null || userUpdateRequestDto.getNickname().isBlank()) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("공백은 닉네임으로 사용할 수 없습니다", 400));
        }

        // 이미 있는 닉네임인 경우
        if (userService.isExistNickname(userUpdateRequestDto.getNickname())
                && userService.notMyNickname(userUpdateRequestDto.getAuthUuid(), userUpdateRequestDto.getNickname())) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("중복된 닉네임입니다.", 400));
        }

        userService.updateUserInfo(userUpdateRequestDto);
        return ResponseEntity.ok().body(BaseResponseBody.of("내 정보 수정 완료", 200));
    }

    @PatchMapping(value = "/image")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "이미지 수정 성공."),
            @ApiResponse(responseCode = "400", description = "이미지 수정 실패. 로그인 중이 아니거나 비정상적인 authUuid 이거나 image가 비었거나"),
    })
    public ResponseEntity<?> changeMyImage(
            @RequestParam("authUuid") String authUuid,
            @RequestPart("image") MultipartFile image) {
        // authUuid 가 세션에 없으면 로그아웃 상태 -> return
        String UPLOADED_FOLDER = "/app/data/upload/profile_image/";
        String fileName = image.getOriginalFilename();
        // String path = UPLOADED_FOLDER+System.currentTimeMillis()+fileName;
        String path = UPLOADED_FOLDER + System.currentTimeMillis() + fileName;

        // 이미지 로컬에 저장
        try {
            image.transferTo(new File(path));
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(BaseResponseBody.of("파일 업로드 실패", 400));
        }

        // user의 address 에 해당 파일 경로 저장
        userService.updateProfileImage(authUuid, path);

        // 정상적으로 업로드 완료
        return ResponseEntity.ok().body(null);
    }

    @GetMapping(value = "/mynoti/n/{nickName}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "fcm 토큰, AuthUuid 조회."),
            @ApiResponse(responseCode = "400", description = "fcm 토큰, AuthUuid 조회 실패. 로그인 중이 아니거나 비정상적인 nickName."),
    })
    public ResponseEntity<?> getUserFcmTokenAndAuthUuid(@PathVariable String nickName) {
        if (nickName == null) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("비정상적인 nickName.", 400));
        }
        UserAlarmResponse userAlarmResponse = userService.getUserFcmTokenAndAuthUuid(nickName);
        return ResponseEntity.ok().body(userAlarmResponse);
    }

    @GetMapping(value = "/mynoti/a/{authUuid}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "fcm 토큰, NickName 조회."),
            @ApiResponse(responseCode = "400", description = "fcm 토큰, NickName 조회 실패. 로그인 중이 아니거나 비정상적인 nickName."),
    })
    public ResponseEntity<?> getUserFcmTokenAndNickName(@PathVariable String authUuid) {
        if (authUuid == null) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("비정상적인 authUuid.", 400));
        }
        UserAlarmNickNameResponse userAlarmResponse = userService.getUserFcmTokenAndNickName(authUuid);
        return ResponseEntity.ok().body(userAlarmResponse);
    }

    @GetMapping(value = "/teaminfo/{authUuid}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "팀정보 조회."),
            @ApiResponse(responseCode = "400", description = "팀정보 조회 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> getTeamInfo(@PathVariable String authUuid) {
        if (authUuid == null) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("비정상적인 authUuid.", 400));
        }
        String teamId = userService.getUserTeamId(authUuid);
        return ResponseEntity.ok().body(teamId);
    }

    @GetMapping(value = "/teamleader/{teamId}")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "팀 리더 조회."),
            @ApiResponse(responseCode = "400", description = "팀정보 조회 실패. 로그인 중이 아니거나 비정상적인 authUuid."),
    })
    public ResponseEntity<?> getTeamLeader(@PathVariable String teamId) {
        if (teamId == null) {
            return ResponseEntity.badRequest().body(BaseResponseBody.of("비정상적인 teamId.", 400));
        }
        UserTeamleaderResponseDto userTeamleaderResponseDto = userService.getTeamLeader(teamId);
        return ResponseEntity.ok().body(userTeamleaderResponseDto);
    }

    @GetMapping("/teamUsers/{teamId}")
    public ResponseEntity<?> getTeamMembers(@PathVariable int teamId) {
        List<UserRes> result = userService.getUsersByTeamId(teamId);
        return ResponseEntity.ok().body(result);
    }

}

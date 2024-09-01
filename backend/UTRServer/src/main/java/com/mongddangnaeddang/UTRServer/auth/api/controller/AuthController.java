package com.mongddangnaeddang.UTRServer.auth.api.controller;

import com.mongddangnaeddang.UTRServer.auth.api.dto.request.AuthAutoLoginDto;
import com.mongddangnaeddang.UTRServer.auth.api.dto.request.AuthDeleteLogoutDto;
import com.mongddangnaeddang.UTRServer.auth.api.dto.request.AuthSignupLoginDto;
import com.mongddangnaeddang.UTRServer.auth.api.dto.response.AuthResponseDto;
import com.mongddangnaeddang.UTRServer.auth.api.dto.RawIdNicknameDto;
import com.mongddangnaeddang.UTRServer.auth.api.service.AuthServiceImpl;
import com.mongddangnaeddang.UTRServer.auth.api.utility.JwtTokenProvider;
import com.mongddangnaeddang.UTRServer.auth.db.entity.UserAuth;
import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.common.BaseResponseBody;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ThreadLocalRandom;

@CrossOrigin(origins = "*")
@Tag(name = "Auth", description = "Auth Controller.")
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthServiceImpl authService; // user_auth table 관련 작업
    @Autowired
    JwtTokenProvider provider;
    private final String defaultImagePath = "/app/data/upload/profile_image/userDefaultImage.PNG";

    // 회원가입 + 로그인
    @PostMapping(value = "/login")
    @Operation(summary = "로그인", description = "AT, vendor 전달 받으면 고유아이디 응답")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "로그인 성공."),
            @ApiResponse(responseCode = "400", description = "로그인 실패. 비정상적인 AT."),
    })
    public ResponseEntity<?> login(
            @RequestBody AuthSignupLoginDto authSignupLoginDto) {
        // 클라이언트에서 받아온 정보로 authUuid 생성
        String vendor = authSignupLoginDto.getVendor();
        String fcmToken = authSignupLoginDto.getFcmToken();
        String rawId = authSignupLoginDto.getRawId();
        String defaultNickname = authSignupLoginDto.getDefaultNickname();
        String authUuid = vendor + "_" + rawId;

        System.out.println("@@@@@@@@@@@@@@@ FCM Token: " + fcmToken);

        // 랜덤한 4자리 숫자 생성
        int randomNum = ThreadLocalRandom.current().nextInt(1000, 10000);
        String newbieNickname = vendor + "_" + defaultNickname + "_" + randomNum;
        String token = provider.createToken(authUuid);

        // authUuid, token을 담은 응답 객체 생성
        AuthResponseDto authResponseDto = new AuthResponseDto();
        authResponseDto.setAuthUuid(authUuid);
        authResponseDto.setToken(token);

        if (authService.checkUserExists(authUuid)) { // 기가입자 -> 토큰 갱신 후 응답
            authService.updateToken(authUuid, token, fcmToken);
        } else { // 신규가입자 -> 회원가입 처리, 토큰 갱신 후 응답
            // user_auth 테이블에 저장 (회원가입 처리)
            UserAuth ua = new UserAuth(authUuid, vendor, token, rawId);
            authService.addNewUserAuth(ua);
            // user_profile 테이블 저장 (회원정보 기본값으로 삽입)
            UserProfile up = new UserProfile(authUuid, newbieNickname, "안녕하세요.", false, defaultImagePath, fcmToken, -1, null);
            authService.addNewUserProfile(up);
        }
        return ResponseEntity.status(200).body(authResponseDto);
    }

    // 자동로그인
    @PostMapping(value = "/autologin")
    @Operation(summary = "자동로그인", description = "JWT, authUuid 전달 받으면 로그인 여부 응답")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "로그인 성공."),
            @ApiResponse(responseCode = "400", description = "로그인 실패."),
    })
    public ResponseEntity<?> autoLogin(
            @RequestHeader(value = "accessToken", required = true) String accessToken,
            @RequestBody AuthAutoLoginDto authAutoLoginDto) {

        // authUuid 와 accessToken 확인
        String authUuid = authAutoLoginDto.getAuthUuid();
        String fcmToken = authAutoLoginDto.getFcmToken();

        System.out.println("@@@@@@@@@@@@@@@ FCM Token: " + fcmToken);

        boolean check = authService.checkAccessTokenOwnership(authUuid, accessToken);
        if (!check)
            return ResponseEntity.status(400).body(BaseResponseBody.of("로그인 실패.", 400)); // authUuid의 accessToken != 전달받은 accessToken
        authService.updateFcmToken(authUuid, fcmToken);
        return ResponseEntity.status(200).body(BaseResponseBody.of("로그인 성공.", 200));
    }

    // 로그아웃
    @PostMapping(value = "/logout")
    @Operation(summary = "로그아웃", description = "accessToken, authUuid 전달 받아 검증 후 로그아웃")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "로그아웃 성공."),
            @ApiResponse(responseCode = "400", description = "jwt 인증 실패."),
    })
    public ResponseEntity<?> logout(
            @RequestHeader(value = "accessToken", required = true) String accessToken,
            @RequestBody AuthDeleteLogoutDto authDeleteLogoutDto) {
        boolean check = authService.checkAccessTokenOwnership(authDeleteLogoutDto.getAuthUuid(), accessToken);
        if(!check)
            return ResponseEntity.status(400).body(null);
        authService.deleteToken(authDeleteLogoutDto.getAuthUuid());
        return ResponseEntity.status(200).body(BaseResponseBody.of("로그아웃 성공.", 200));
    }

    // 회원탈퇴
    @DeleteMapping(value = "/delete")
    @Operation(summary = "회원탈퇴", description = "accessToken, authUuid 전달 받아 검증 후 회원탈퇴")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "회원탈퇴 성공."),
            @ApiResponse(responseCode = "400", description = "jwt 인증 실패."),
    })
    public ResponseEntity<?> delete(
            @RequestHeader(value = "accessToken", required = true) String accessToken,
            @RequestBody AuthDeleteLogoutDto authDeleteLogoutDto) {
        boolean check = authService.checkAccessTokenOwnership(authDeleteLogoutDto.getAuthUuid(), accessToken);
        if(!check)
            return ResponseEntity.status(400).body(null);
        // 회원정보 삭제
        authService.deleteCurrentUserProfile(authDeleteLogoutDto.getAuthUuid());
        authService.deleteCurrentUserAuth(authDeleteLogoutDto.getAuthUuid());
        return ResponseEntity.status(200).body(BaseResponseBody.of("회원탈퇴 성공.", 200));
    }
}

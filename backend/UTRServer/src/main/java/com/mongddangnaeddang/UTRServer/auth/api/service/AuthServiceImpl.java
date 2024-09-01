package com.mongddangnaeddang.UTRServer.auth.api.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongddangnaeddang.UTRServer.auth.api.dto.RawIdNicknameDto;
import com.mongddangnaeddang.UTRServer.auth.db.entity.UserAuth;
import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.auth.db.repository.UserAuthRepository;
import com.mongddangnaeddang.UTRServer.auth.db.repository.UserProfileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;

@Service
public class AuthServiceImpl implements AuthService {
    @Autowired
    private UserAuthRepository userAuthRepository;
    @Autowired
    private UserProfileRepository userProfileRepository;

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public boolean checkUserExists(String authUuid) {
        return userAuthRepository.existsById(authUuid);
    }

    @Override
    public RawIdNicknameDto getUserInfoFromVendor(String accessToken, String vendor) {
        ResponseEntity<String> response = null;
        RawIdNicknameDto rawIdNicknameDto = new RawIdNicknameDto();
        ObjectMapper objectMapper = new ObjectMapper();

        if (vendor.equals("kakao")) {
            try {
                // AT를 인증 서버로 보내 유저 정보 가져오기
                String url = "https://kapi.kakao.com/v2/user/me";
                HttpHeaders headers = new HttpHeaders();
                headers.set("Authorization", "Bearer " + accessToken);
                HttpEntity<String> entity = new HttpEntity<>(headers);
                response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
            } catch (HttpClientErrorException e) {
                return rawIdNicknameDto;
            }

            // JsonString에서 rawId, nickname 추출
            try {
                JsonNode rootNode = objectMapper.readTree(response.getBody());
                String rawId = rootNode.path("id").asText();
                String nickname = rootNode.path("properties").path("nickname").asText();
                rawIdNicknameDto.setRawId(rawId);
                rawIdNicknameDto.setNickname(nickname);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (vendor.equals("naver")) {
            // TODO:
            // 네이버로그인구현
        } else if (vendor.equals("google")) {
            // TODO:
            // 구글로그인구현
        }
        return rawIdNicknameDto;
    }


    // 신규 유저 회원가입 처리
    @Override
    public void addNewUserAuth(UserAuth userAuth) {
        userAuthRepository.save(userAuth);
    }

    // 신규 유저 기본 정보 세팅
    @Override
    public void addNewUserProfile(UserProfile userProfile) {
        userProfileRepository.save(userProfile);
    }


    // 유저 회원 탈퇴
    @Override
    public void deleteCurrentUserProfile(String authUuid) {
        userProfileRepository.deleteById(authUuid);
    }

    @Override
    public void deleteCurrentUserAuth(String authUuid) {
        userAuthRepository.deleteById(authUuid);
    }

    @Override
    public void updateToken(String authUuid, String token, String fcmToken) {
        UserAuth ua = userAuthRepository.findByAuthUuid(authUuid);
        UserProfile up = userProfileRepository.findByAuthUuid(authUuid);
        ua.setToken(token);
        up.setFcmToken(fcmToken);
        userAuthRepository.save(ua);
        userProfileRepository.save(up);
    }

    @Override
    public void deleteToken(String authUuid) { // 로그아웃 시 db에서 fcmtoken, accesstoken 삭제
        updateFcmToken(authUuid, null);
        UserAuth ua = userAuthRepository.findByAuthUuid(authUuid);
        ua.setToken(null);
        userAuthRepository.save(ua);
    }

    @Override
    public boolean checkAccessTokenOwnership(String authUuid, String accessToken) {
        UserAuth ua = userAuthRepository.findByAuthUuid(authUuid);
        return ua.getToken().equals(accessToken);
    }

    @Override
    public void updateFcmToken(String authUuid, String fcmToken) {
        UserProfile up = userProfileRepository.findByAuthUuid(authUuid);
        up.setFcmToken(fcmToken);
        userProfileRepository.save(up);
    }
}

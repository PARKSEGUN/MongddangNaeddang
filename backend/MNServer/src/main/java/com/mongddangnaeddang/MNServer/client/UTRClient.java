package com.mongddangnaeddang.MNServer.client;

import com.mongddangnaeddang.MNServer.game.dto.request.TeamUserRequestDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.TeamUserResponseDTO;
import com.mongddangnaeddang.MNServer.notification.dto.UserAlarmDto;
import com.mongddangnaeddang.MNServer.notification.dto.UserAuthUuidResponse;
import com.mongddangnaeddang.MNServer.redis.dto.response.TeamDetailResponseDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;


@FeignClient(name="UTRSERVER", dismiss404 = true
, path ="/api")
public interface UTRClient {

    // userId로 특정 유저 fcmToken 받아오기
    @GetMapping("/user/mynoti/n/{nickName}")
    UserAlarmDto getNickNameResponse(@PathVariable String nickName);

    // user nickname으로 특정 유저 teamId 받아오기
    @GetMapping("/user/teaminfo/{authUuid}")
    String getTeamId(@PathVariable String authUuid);

    // teamId로 teamName 받아오기
    @GetMapping("/team/name/{teamId}")
    String getTeamName(@PathVariable int teamId);

    // teamId로 team 정보 모두 받아오기
    @GetMapping("/team/detail/{teamId}")
    ResponseEntity<TeamDetailResponseDTO> getTeamDetail(@PathVariable("teamId") int teamId);

    // uuid로 특정 유저 fcmToken 받아오기
    @GetMapping("/user/mynoti/a/{authUuid}")
    UserAuthUuidResponse getUserAuthUuidResponse(@PathVariable String authUuid);

    // teamName으로 teamId 받아오기
    @GetMapping("/team/n/{teamName}")
    int getTeamIdByTeamName(@PathVariable("teamName") String teamName);

    // teamId로 팀원 정보 받아오기
    @GetMapping("/user/teamUsers/{teamId}")
    ResponseEntity<List<TeamUserResponseDTO>> getTeamMembers(@PathVariable int teamId);

}

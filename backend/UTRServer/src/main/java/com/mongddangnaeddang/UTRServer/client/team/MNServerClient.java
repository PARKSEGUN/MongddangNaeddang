package com.mongddangnaeddang.UTRServer.client.team;

import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.request.UserContributionFeignReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.*;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.AlarmToUserReq;
import com.mongddangnaeddang.UTRServer.user.api.dto.request.AlarmRequestDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@FeignClient(name = "MNSERVER", path = "/api")
public interface MNServerClient {
    @GetMapping("/redis/rank/team/{teamId}")
    TeamDetailRankFeignRes getTeamRankByTeamId(@PathVariable("teamId") int teamId);

    @PostMapping("/redis/user")
    UserDistanceFeignRes getUserDistance(@RequestBody String profileUuid);

    @GetMapping("/redis/rank/team")
    List<TeamRankFeignRes> getTeamRank(@RequestParam("type") String type, @RequestParam("range") String range);

    @GetMapping("/redis/rank/user")
    List<UserRankFeignRes> getUserRank();

    @PostMapping("/notification/join")
    void alarmByJoin(@RequestBody AlarmToUserReq alarmToUserReq);

    @PostMapping("/notification/leave")
    void alarmByLeave(@RequestBody AlarmToUserReq alarmToUserReq);

    @GetMapping("/notification/teamcreate")
    void alarmByTeamCreate(@RequestParam("teamName") String teamName, @RequestParam("profileUuid") String profileUuid);

    @GetMapping("/notification/delete")
    void alarmByTeamDelete(@RequestParam("teamName") String teamName, @RequestParam("fcmToken") String fcmToken);

    @PostMapping("/game")
    UserContributionFeignRes getTeamContribution(@RequestBody UserContributionFeignReq userContributionFeignReq);

    @DeleteMapping("/redis/team/{teamId}")
    void deleteTeamOfRedis(@PathVariable int teamId);

    @GetMapping("/game/myhistory/{authUuid}")
    ResponseEntity<?> getMyHistory(@RequestParam String authUuid);

    @GetMapping("/badge/mybadge/{authUuid}")
    ResponseEntity<?> getMyBadge(@RequestParam String authUuid);

    @PostMapping("/redis/user")
    ResponseEntity<?> getDistanceSum(@RequestBody String authUuid);

    @PostMapping("notification/friendresult")
    ResponseEntity<?> sendFriendResultAlarm(@RequestBody AlarmRequestDto alarmRequestDto);


}
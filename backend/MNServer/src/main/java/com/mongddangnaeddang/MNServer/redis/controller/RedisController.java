package com.mongddangnaeddang.MNServer.redis.controller;

import com.mongddangnaeddang.MNServer.redis.dto.request.MapRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.TeamRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.UserRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.response.*;
import com.mongddangnaeddang.MNServer.redis.service.RedisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/redis")
@Tag(name = "Redis API", description = " 레디스 ")
public class RedisController {

    private final RedisService redisService;

    // - 주변 영역 반환
    @PostMapping("/map")
    @Operation(summary = "주변 영역 조회", description = "특정 영역과 겹치는 모든 영역 조회")
    public ResponseEntity<?> getMap(@RequestBody MapRequestDTO mapRequestDTO) {
        List<MapResponseDTO> polygons = redisService.getSurroundingArea(mapRequestDTO);
        return new ResponseEntity<>(polygons, HttpStatus.OK);
    }
    
    // - 팀 정보 반환
    @PostMapping("/team")
    @Operation(summary = "팀 정보 조회", description = "팀 누적거리, 누적영역, 폴리곤 조회")
    public ResponseEntity<?> getTeam(@RequestBody String id) {
        TeamResponseDTO teamResponseDTO = redisService.getTeam(id);
        return new ResponseEntity<>(teamResponseDTO, HttpStatus.OK);
    }

    // - 팀 정보 수정
    @PatchMapping("/team")
    @Operation(summary = "팀 정보 수정", description = "팀 누적거리 갱신 & 누적영역, 보유폴리곤 변경")
    public ResponseEntity<?> updateTeam(@RequestBody TeamRequestDTO teamRequestDTO) {
        TeamSumResponseDTO teamResponseDTO = redisService.updateTeam(teamRequestDTO);
        return new ResponseEntity<>(teamResponseDTO, HttpStatus.OK);
    }

    // - 팀 정보 삭제
    @DeleteMapping("/team/{teamId}")
    @Operation(summary = "팀 정보 삭제", description = "팀 해체 시 Redis 내 Team 정보 제거")
    public ResponseEntity<?> deleteTeam(@PathVariable("teamId") int teamId) {
        redisService.deleteTeam(Integer.toString(teamId));
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
    
    // - 유저 정보 반환
    @PostMapping("/user")
    @Operation(summary = "유저 정보 조회", description = "유저 누적거리 조회")
    public ResponseEntity<?> getUser(@RequestBody String authUuid) {
        UserResponseDTO userResponseDTO = redisService.getUser(authUuid);
        return new ResponseEntity<>(userResponseDTO, HttpStatus.OK);
    }

    // - 유저 정보 수정
    @PatchMapping("/user")
    @Operation(summary = "유저 정보 수정", description = "유저 누적거리 갱신")
    public ResponseEntity<?> updateUser(@RequestBody UserRequestDTO userRequestDTO) {
        UserResponseDTO userResponseDTO = redisService.updateUser(userRequestDTO);
        return new ResponseEntity<>(userResponseDTO, HttpStatus.OK);
    }

    // - 팀 랭킹 계산
    @PostMapping("/rank/team")
    @Operation(summary = "팀 랭킹 계산", description = "팀의 거리&면적 랭킹 계산")
    public ResponseEntity<?> calcTeamRanking() {
        redisService.calcTeamRanking();
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    // - 특정 팀 랭킹 조회
    @GetMapping("/rank/team/{teamId}")
    @Operation(summary = "특정 팀 랭킹 조회", description = "특정 팀의 거리&면적 랭킹 조회")
    public ResponseEntity<?> getTeamRanking(@PathVariable("teamId") String teamId) {
        TeamRankResponseDTO teamRankResponseDTO = redisService.getTeamRanking(teamId);
        return new ResponseEntity<>(teamRankResponseDTO, HttpStatus.OK);
    }

    // - 조건에 맞는 팀 랭킹 조회
    @GetMapping("/rank/team")
    @Operation(summary = "조건에 따른 팀 랭킹 조회", description = "조건 : type(area, distance), range(0, 100)")
    public ResponseEntity<?> getTeamRankings(@RequestParam("type") String type, @RequestParam int range) {
        List<AllTeamRankResponseDTO> teamRankResponseDTOs = redisService.getAllTeamRanking(type, range-1);
        return new ResponseEntity<>(teamRankResponseDTOs, HttpStatus.OK);
    }

    // - 유저 랭킹 계산
    @PostMapping("/rank/user")
    @Operation(summary = "사용자 랭킹 계산", description = "사용자 거리 랭킹 계산")
    public ResponseEntity<?> calcUserRanking() {
        redisService.calcUserRanking();
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    // - 유저 Top 100 랭킹 조회
    @GetMapping("/rank/user")
    @Operation(summary = "사용자 Top 100 랭킹 조회", description = "사용자 Top 100 랭킹 조회")
    public ResponseEntity<?> getUserRankings() {
        List<UserRankResponseDTO> userRankResponseDTOS = redisService.getAllUserRanking();
        return new ResponseEntity<>(userRankResponseDTOS, HttpStatus.OK);
    }
    
    // - 전 달 Redis 데이터 Map으로 back-up
    @PostMapping("/backup")
    @Operation(summary = "Map 백업 데이터 생성", description = "전 달 데이터 Map DB 이전")
    public ResponseEntity<?> backupToMap() {
        redisService.backupToMap();
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
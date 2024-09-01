package com.mongddangnaeddang.UTRServer.team.api.controller;

import com.mongddangnaeddang.UTRServer.team.api.dto.response.RankRes;
import com.mongddangnaeddang.UTRServer.team.api.service.RankService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "랭크 API", description = "랭크 API Swagger")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/rank")
public class RankController {

    private final RankService rankService;


    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/team/area", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "땅 면적에 따른 팀 랭킹", description = "<strong>땅 면적에 따른 팀 상위 100팀의 랭크</strong>를 조회 한다.")
    public ResponseEntity<?> getTeamRankByArea() {
        List<RankRes> rankResult = rankService.getTeamRank("area", "100");
        return ResponseEntity.status(HttpStatus.OK).body(rankResult);
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/team/distance", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "달린 거리에 따른 팀 랭킹", description = "<strong>달린 거리에 따른 팀 상위 100팀의 랭크</strong>를 조회 한다.")
    public ResponseEntity<?> getTeamRankByDistance() {
        List<RankRes> rankResult = rankService.getTeamRank("distance", "100");
        return ResponseEntity.status(HttpStatus.OK).body(rankResult);
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/user/distance", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "달린 거리에 따른 개인 랭킹", description = "<strong>달린 거리에 따른 개인 상위 100팀의 랭크</strong>를 조회 한다.")
    public ResponseEntity<?> getUserRankByDistance() {
        List<RankRes> rankResult = rankService.getUserRankByDistance();
        return ResponseEntity.status(HttpStatus.OK).body(rankResult);
    }
}

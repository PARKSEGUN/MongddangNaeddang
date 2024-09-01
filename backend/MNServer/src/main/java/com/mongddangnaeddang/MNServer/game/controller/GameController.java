package com.mongddangnaeddang.MNServer.game.controller;

import com.mongddangnaeddang.MNServer.game.dto.request.GameContributionDTO;
import com.mongddangnaeddang.MNServer.game.dto.request.GameRequestDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.GameResponseDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.UserMoveHistoryResponseDTO;
import com.mongddangnaeddang.MNServer.game.service.GameService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/game")
@RequiredArgsConstructor
@Tag(name = "Game API", description = " 게임 ")
public class GameController {

    private final GameService gameService;

    // - 게임 종료
    @PostMapping("/finish")
    @Operation(summary = "달리기 종료", description = "달리기 종료 후 로직 수행")
    public ResponseEntity<?> createMoveHistory(@RequestBody GameRequestDTO gameRequestDTO){
        GameResponseDTO gameResponseDTO = gameService.finishGame(gameRequestDTO);
        return new ResponseEntity<>(gameResponseDTO, HttpStatus.CREATED);
    }

    // - 유저 게임 기록 조회 (마이페이지용)
    @GetMapping("/myhistory/{authUuid}")
    @Operation(summary = "유저 게임 기록 조회", description = "특정 사용자에 대한 과거 이력 조회")
    public ResponseEntity<?> getMoveHistory(@PathVariable("authUuid") String authUuid){
        List<UserMoveHistoryResponseDTO> moveHistories = gameService.getUserMoveHistory(authUuid);
        return new ResponseEntity<>(moveHistories, HttpStatus.OK);
    }

    // 특정 유저가 특정 팀 합류 이후, 총 뛴거리 리턴.
    @PostMapping("")
    @Operation(summary ="유저 joinAt 이후로 총 뛴거리 조회", description = "특정 사용자에 대한 특정 팀에 joinAt 이후 총 뛴거리 리턴")
    public ResponseEntity<?> getTeamMoveSum(@RequestBody GameContributionDTO gameContributionDTO){
        LocalDateTime localDateTime = gameContributionDTO.getJoinAt().toLocalDateTime();
        double sumMoveHistory = gameService.getTeamMoveSum(gameContributionDTO.getAuthUuid(),localDateTime);
        Map<String, Double> resSum = new HashMap<>();
        resSum.put("distance",sumMoveHistory);
        return new ResponseEntity<Map<String,Double>>(resSum, HttpStatus.OK);
    }
}

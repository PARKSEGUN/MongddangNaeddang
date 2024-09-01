package com.mongddangnaeddang.MNServer.game.service;

import com.mongddangnaeddang.MNServer.game.dto.request.GameRequestDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.GameResponseDTO;
import com.mongddangnaeddang.MNServer.game.dto.response.UserMoveHistoryResponseDTO;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public interface GameService {
    public GameResponseDTO finishGame(GameRequestDTO gameRequestDTO);
    public List<UserMoveHistoryResponseDTO> getUserMoveHistory(String authUuid);

    double getTeamMoveSum(String authUuid, LocalDateTime joinAt);
}

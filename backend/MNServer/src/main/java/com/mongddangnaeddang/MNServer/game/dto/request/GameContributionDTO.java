package com.mongddangnaeddang.MNServer.game.dto.request;

import lombok.Data;
import java.sql.Timestamp;
@Data
public class GameContributionDTO {
    private String authUuid;
    private Timestamp joinAt;
}

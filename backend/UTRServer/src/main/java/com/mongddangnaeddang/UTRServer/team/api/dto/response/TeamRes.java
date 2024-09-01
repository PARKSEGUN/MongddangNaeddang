package com.mongddangnaeddang.UTRServer.team.api.dto.response;

import com.mongddangnaeddang.UTRServer.team.api.dto.feignClient.response.TeamDetailRankFeignRes;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema
public class TeamRes {
    @Schema(name = "teamId", example = "1")
    private int teamId;
    @Schema(name = "name", example = "teamNameTest")
    private String name;
    @Schema(name = "comment", example = "잘난팀입니다")
    private String comment;
    @Schema(name = "color", example = "#001122")
    private String color;
    @Schema(name = "logo", example = "test.jpg")
    private String logo;
    @Schema(name = "memberCount", example = "5")
    private int memberCount;
    @Schema(name = "areaSum", example = "123.123")
    private double areaSum;
    @Schema(name = "distanceSum", example = "12.12")
    private double distanceSum;

    @Schema(name = "areaRank", example = "1")
    private int areaRank;

    @Schema(name = "distanceRank", example = "1")
    private int distanceRank;

    public double getSortValue(int sortType) {
        if (sortType == 0) {
            return teamId;
        } else if (sortType == 1) {
            return areaSum;
        }
        return distanceSum;
    }

    public void setMetrics(TeamDetailRankFeignRes teamDetailRankFeignRes) {
        this.distanceSum = teamDetailRankFeignRes.getDistanceSum();
        this.areaSum = teamDetailRankFeignRes.getAreaSum();
        this.distanceRank = teamDetailRankFeignRes.getDistanceRank();
        this.areaRank = teamDetailRankFeignRes.getAreaRank();
    }
}

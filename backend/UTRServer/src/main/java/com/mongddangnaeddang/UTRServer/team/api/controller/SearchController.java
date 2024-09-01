package com.mongddangnaeddang.UTRServer.team.api.controller;

import com.mongddangnaeddang.UTRServer.common.BaseResponseBody;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamSearchPostReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import com.mongddangnaeddang.UTRServer.team.api.service.TeamSearchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "검색 API", description = "검색 API Swagger")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/team/search")
public class SearchController {

    private final TeamSearchService teamSearchService;


    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @Operation(summary = "팀 검색", description = "<strong>검색어와 정렬조건</strong>을 통해 팀 검색을 한다.")
    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getTeamByName(@RequestBody TeamSearchPostReq teamSearchPostReq) {
        long startTime = System.currentTimeMillis();
        /*
         *   정렬 조건이 범위를 벗어났을때, 입력을 하지 않아도 default로 0으로 설정됨
         * */
        if (teamSearchPostReq.getSortType() < 0 || 2 < teamSearchPostReq.getSortType()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(BaseResponseBody.of("올바른 정렬 조건을 입력해주세요", HttpStatus.BAD_REQUEST.value()));
        }
        /*
         *   검색어를 입력하지 않았다면 초기화
         * */

        if (teamSearchPostReq.getKeyword() == null) {
            teamSearchPostReq.setKeyword("");
        }
        List<TeamRes> teamResResult = teamSearchService.searchTeamByName(teamSearchPostReq);

        long endTime = System.currentTimeMillis();
        long elapsedTime = endTime - startTime;
        System.out.println("경과시간 : " + elapsedTime + "ms");
        return ResponseEntity.status(200).body(teamResResult);
    }
}

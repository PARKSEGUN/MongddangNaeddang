package com.mongddangnaeddang.UTRServer.team.api.controller;

import com.mongddangnaeddang.UTRServer.common.BaseResponseBody;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.*;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import com.mongddangnaeddang.UTRServer.team.api.service.TeamSearchService;
import com.mongddangnaeddang.UTRServer.team.api.service.TeamService;
import com.mongddangnaeddang.UTRServer.team.db.entity.Team;
import com.sun.jdi.request.InvalidRequestStateException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.NoSuchElementException;

@Tag(name = "팀 API", description = "팀 API Swagger")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/team")
public class TeamController {

    private static final Logger logger = LoggerFactory.getLogger(TeamController.class);

    private final TeamService teamService;
    private final TeamSearchService teamSearchService;

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 생성", description = "<strong>팀 이름, 팀 설명, 팀 색상, 팀 로고</strong>를 통해 팀 가입을 한다.")
    public ResponseEntity<?> create(
            @RequestPart(value = "teamCreatePostReq") TeamCreatePostReq teamCreatePostReq,
            @Parameter(description = "multipart/form-data 형식의 이미지 리스트를 input으로 받습니다. 이때 key 값은 multipartFile 입니다.")
            @RequestPart(value = "teamLogo", required = false) MultipartFile teamLogo) {
        String imgPath = "";
        if (teamLogo != null && !teamLogo.isEmpty()) {
            try {
                imgPath = teamService.uploadImg(teamLogo);
                logger.info("이미지 경로: " + imgPath);
            } catch (IOException e) {
                return ResponseEntity.status(400).body(BaseResponseBody.of("프로필 사진과정 중 에러 발생", 400));
            }
        } else {
            logger.info("내가 보이니?");
            return ResponseEntity.status(500).body(BaseResponseBody.of("디폴트이미지가 구현되지 않았음", 500));
        }
        Team team = teamService.createTeam(teamCreatePostReq, imgPath);
        // jaehyun : 팀 토큰 firebase에 저장 코드 작성
        logger.info("내가 보여요?");
        //여기까지 수정필요
        return ResponseEntity.status(200).body(BaseResponseBody.of("OK", 200));
//        return ResponseEntity.status(200).body(BaseResponseBody.of(imgPath, 200));
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 상세정보", description = "<strong>팀 ID</strong>를 통해 팀 상세정보를 조회 한다.")
    public ResponseEntity<?> getTeamById(
            @Parameter(required = true, description = "팀 고유 번호")
            @RequestBody
            TeamIdReq teamIdReq) {
        TeamRes teamRes = teamService.detailByTeamId(teamIdReq.getTeamId());
        if (teamRes == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(BaseResponseBody.of("ID값에 맞는 팀이 존재하지 않습니다.", 404));
        } else {
            return new ResponseEntity<>(teamRes, HttpStatus.OK);
        }
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/name/{teamId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 이름 조회", description = "<strong>팀 ID</strong>를 통해 팀 이름을 조회 한다.")
    public ResponseEntity<?> getTeamName(@PathVariable int teamId) {
        TeamRes teamRes = teamService.getTeamNameByTeamId(teamId);
        if (teamRes == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(BaseResponseBody.of("ID값에 맞는 팀이 존재하지 않습니다.", 404));
        } else {
            return new ResponseEntity<>(teamRes.getName(), HttpStatus.OK);
        }
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping(value = "/members", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀원들 정보 가져오기", description = "<strong>팀 ID</strong>를 통해 모든 팀원들의 정보를 조회 한다.")
    public ResponseEntity<?> getUsersByTeamId(
            @Parameter(required = true, description = "팀 고유 번호")
            @RequestBody
            UsersInTeamPostReq usersInTeamPostReq) {
        List<UserRes> result = teamService.getUsersByTeamId(usersInTeamPostReq.getTeamId());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }


    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @DeleteMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 해체", description = "<strong> 팀 ID, isLeader</strong>를 통해 팀을 해체한다.")
    public ResponseEntity<?> deleteTeamById(
            @Parameter(required = true, description = "팀 고유 번호")
            @RequestBody
            TeamDeleteReq teamDeleteReq) {
        if (teamDeleteReq.isLeader()) {
            if (!teamService.isTeamMemberOnlyOne(teamDeleteReq.getTeamId())) {
                return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).body(BaseResponseBody.of("팀원이 존재하기때문에 팀을 해체할 수 없습니다.", 406));
            } else {
                teamService.deleteTeamById(teamDeleteReq.getTeamId());
                return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of("팀이 해체되었습니다.", 200));
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).body(BaseResponseBody.of("리더가 아니기때문에 해체할 수 없습니다.", 406));
        }

    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })

    @PostMapping(value = "/join"/*, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE*/)
    @Operation(summary = "팀 가입", description = "<strong> 유저 ID, Team ID</strong>를 통해 유저를 팀에 가입시킨다.")
    public ResponseEntity<?> signUp(
            @Parameter(required = true, description = "팀 가입 유저 ID, 팀 ID")
            @RequestBody
            TeamUpdateRes teamUpdateRes) {
        try {
            teamService.signUp(teamUpdateRes);
            return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of("정상적으로 팀에 가입되었습니다", 200));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(BaseResponseBody.of("User ID 또는 Team ID 값이 존재하지 않습니다", 400));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(BaseResponseBody.of("User는 이미 Team이 존재합니다!", 400));
        }
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping(value = "/leave"/*, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE*/)
    @Operation(summary = "팀 탈퇴", description = "<strong> 유저 ID</strong>를 통해 유저의 팀을 탈퇴한다.")
    public ResponseEntity<?> leaveTeam(
            @Parameter(required = true, description = "팀 가입 유저 ID")
            @RequestBody TeamUpdateRes teamUpdateRes) {
        try {
            teamService.leaveTeam(teamUpdateRes);
            return ResponseEntity.status(HttpStatus.OK).body(BaseResponseBody.of("성공", 200));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(BaseResponseBody.of("User ID 또는 Team ID 값이 존재하지 않습니다", 400));
        } catch (InvalidRequestStateException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(BaseResponseBody.of("User는 팀이 존재하지 않습니다", 400));
        }
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping(value = "/leader"/*, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE*/)
    @Operation(summary = "리더의 AuthUuid 조회", description = "<strong> TeamId</strong>를 통해 리더의 AuthUuid를 조회한다.")
    public ResponseEntity<?> getLeaderAuthUuid(
            @Parameter(required = true, description = "팀 ID")
            @RequestBody TeamIdReq teamIdReq) {

        String leaderAuthUuid = teamService.getLeaderAuthUuid(teamIdReq.getTeamId());
        return new ResponseEntity<>(leaderAuthUuid, HttpStatus.OK);
    }

    @GetMapping("/detail/{teamId}")
    public ResponseEntity<?> getTeamDetail(@PathVariable("teamId") int teamId) {
        TeamRes teamRes = teamService.getTeamNameByTeamId(teamId);
        if (teamRes == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(BaseResponseBody.of("ID값에 맞는 팀이 존재하지 않습니다.", 404));
        } else {
            return new ResponseEntity<>(teamRes, HttpStatus.OK);
        }
    }


    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/name/n/{teamName}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 이름 조회", description = "<strong>팀 ID</strong>를 통해 팀 이름을 조회 한다.")
    public int getTeamId(@PathVariable String teamName) {
        int teamId = teamService.getTeamIdByTeamName(teamName);
        return teamId;
    }
}



package com.mongddangnaeddang.UTRServer.image.api.controller;

import com.mongddangnaeddang.UTRServer.image.api.dto.response.ImageRes;
import com.mongddangnaeddang.UTRServer.image.api.service.ImageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@Tag(name = "이미지 API", description = "이미지 API Swagger")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/image")
public class ImageController {

    private final ImageService imageService;

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/team/{teamId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 이미지 가져오기", description = "<strong>팀 ID</strong>를 통해 팀 이미지를 조회 한다.")
    public ResponseEntity<?> getTeamImage(@PathVariable("teamId") int teamId) {
        try {
            ImageRes imageRes = imageService.getTeamImage(teamId);
            return ResponseEntity.ok()
                    .contentType(MediaType.valueOf(imageRes.getMimeType()))
                    .body(imageRes.getImageBytes());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("사진 가져오는 과정에서 에러가 발생했습니다!");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("teamId에 해당하는 팀이 존재하지 않습니다!");
        }
    }

    @GetMapping(value = "/team/name/{name}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "팀 이름으로 팀 이미지 가져오기", description = "<strong>팀 이름</strong>을 통해 팀 이미지를 조회 한다.")
    public ResponseEntity<?> getTeamImageByName(@PathVariable("name") String name) {
        try {
            ImageRes imageRes = imageService.getTeamImageByName(name);
            return ResponseEntity.ok()
                    .contentType(MediaType.valueOf(imageRes.getMimeType()))
                    .body(imageRes.getImageBytes());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("사진 가져오는 과정에서 에러가 발생했습니다!");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("teamId에 해당하는 팀이 존재하지 않습니다!");
        }
    }

    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "404", description = "사용자 없음"),
            @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping(value = "/user/{nickname}", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "유저 이미지 조회", description = "<strong>유저 이름</strong>을 통해 유저 프로필 사진을 조회 한다.")
    public ResponseEntity<?> getUserImage(@PathVariable String nickname) {
        try {
            ImageRes imageRes = imageService.getUserImage(nickname);
            return ResponseEntity.ok()
                    .contentType(MediaType.valueOf(imageRes.getMimeType()))
                    .body(imageRes.getImageBytes());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("사진 가져오는 과정에서 에러가 발생했습니다!");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("nickname에 해당하는 유저가 존재하지 않습니다!");
        }
    }
}

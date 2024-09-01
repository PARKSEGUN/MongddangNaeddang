package com.mongddangnaeddang.UTRServer.image.api.service;

import com.mongddangnaeddang.UTRServer.auth.db.repository.UserProfileRepository;
import com.mongddangnaeddang.UTRServer.image.api.dto.response.ImageRes;
import com.mongddangnaeddang.UTRServer.team.db.repository.TeamRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@Service
@RequiredArgsConstructor

public class ImageServiceImpl implements ImageService {

    private final TeamRepository teamRepository;
    private final UserProfileRepository userProfileRepository;

    @Override
    public ImageRes getTeamImage(int teamId) throws IOException {
        String logoPath = teamRepository.findById(teamId).orElseThrow(RuntimeException::new).getLogo();
        return createImageRes(logoPath);
    }


    @Override
    public ImageRes getUserImage(String nickname) throws IOException {
        String imagePath = userProfileRepository.findByNickname(nickname).getImageAddress();
        return createImageRes(imagePath);
    }

    @Override
    public ImageRes getTeamImageByName(String name) throws IOException, RuntimeException {
        String logoPath = teamRepository.findByName(name).orElseThrow(RuntimeException::new).getLogo();
        return createImageRes(logoPath);

    }


    private static ImageRes createImageRes(String logoPath) throws IOException {
        // 이미지 파일 경로 설정
        File imageFile = new File(logoPath);
        // 파일을 바이트 배열로 읽기
        byte[] imageBytes = Files.readAllBytes(imageFile.toPath());
        // 이미지의 MIME 타입 설정
        String mimeType = Files.probeContentType(imageFile.toPath());
        return new ImageRes(imageBytes, mimeType);
    }
}

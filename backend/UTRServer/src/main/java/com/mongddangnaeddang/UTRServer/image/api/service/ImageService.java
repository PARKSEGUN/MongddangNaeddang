package com.mongddangnaeddang.UTRServer.image.api.service;

import com.mongddangnaeddang.UTRServer.image.api.dto.response.ImageRes;

import java.io.IOException;

public interface ImageService {

    ImageRes getTeamImage(int teamId) throws IOException, RuntimeException;

    ImageRes getUserImage(String nickname) throws IOException, RuntimeException;

    ImageRes getTeamImageByName(String name) throws IOException, RuntimeException;
}

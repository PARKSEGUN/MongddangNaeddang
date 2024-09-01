package com.mongddangnaeddang.UTRServer.team.api.service;

import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamCreatePostReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamUpdateRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.UserRes;
import com.mongddangnaeddang.UTRServer.team.db.entity.Team;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface TeamService {
    Team createTeam(TeamCreatePostReq teamCreatePostReq, String imgPath);

    String uploadImg(MultipartFile teamLogo) throws IOException;

    TeamRes detailByTeamId(int teamId);

    List<UserRes> getUsersByTeamId(int teamId);

    boolean isTeamMemberOnlyOne(int teamId);

    void deleteTeamById(int teamId);

    void signUp(TeamUpdateRes teamUpdateRes);

    void leaveTeam(TeamUpdateRes teamUpdateRes);

    TeamRes getTeamNameByTeamId(int teamId);

    Map<Integer, Integer> createCountMemberMap(List<Integer> teamIds);

//    UserContributionFeignRes getUserContribution(UserContributionReq userContributionReq);

    int getTeamIdByTeamName(String teamName);


    String getLeaderAuthUuid(int teamId);
}


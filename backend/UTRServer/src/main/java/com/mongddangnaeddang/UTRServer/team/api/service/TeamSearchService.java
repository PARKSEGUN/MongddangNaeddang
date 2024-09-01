package com.mongddangnaeddang.UTRServer.team.api.service;

import com.mongddangnaeddang.UTRServer.team.api.dto.request.TeamSearchPostReq;
import com.mongddangnaeddang.UTRServer.team.api.dto.response.TeamRes;

import java.util.List;

public interface TeamSearchService {

    List<TeamRes> searchTeamByName(TeamSearchPostReq teamSearchPostReq);

}

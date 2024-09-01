package com.mongddangnaeddang.MNServer.redis.service;

import com.mongddangnaeddang.MNServer.redis.dto.PolygonDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.MapRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.TeamRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.request.UserRequestDTO;
import com.mongddangnaeddang.MNServer.redis.dto.response.*;
import org.locationtech.jts.geom.Polygon;

import java.util.List;
import java.util.Map;

public interface RedisService {
    // - Map
    public List<MapResponseDTO> getSurroundingArea(MapRequestDTO mapRequestDTO);
    public List<PolygonDTO> getMap(Polygon basePolygon);
    public void backupToMap();

    // - Team
    public TeamSumResponseDTO insertTeam(TeamRequestDTO teamRequestDTO);
    public List<TeamSumResponseDTO> getAllTeams(int mm);
    public TeamResponseDTO getTeam(String id);
    public TeamSumResponseDTO updateTeam(TeamRequestDTO teamRequestDTO);
    public void deleteTeam(String teamId);
    public void deleteTeamPolygon(String teamId, Polygon polygon);

    // - User
    public UserResponseDTO insertUser(UserRequestDTO userRequestDTO);
    public UserResponseDTO getUser(String authUuid);
    public List<UserResponseDTO> getAllUsers();
    public UserResponseDTO updateUser(UserRequestDTO userRequestDTO);

    // - Ranking
    public TeamRankResponseDTO getTeamRanking(String teamId);
    public List<AllTeamRankResponseDTO> getAllTeamRanking(String type, int range);
    public void calcTeamRanking();

    public List<UserRankResponseDTO> getAllUserRanking();
    public void calcUserRanking();
}

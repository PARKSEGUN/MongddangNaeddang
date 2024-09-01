package com.mongddangnaeddang.UTRServer.auth.db.repository;

import com.mongddangnaeddang.UTRServer.auth.db.entity.UserProfile;
import com.mongddangnaeddang.UTRServer.team.db.mapper.TeamMemberCountMapper;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserProfileRepository extends JpaRepository<UserProfile, String> {
    UserProfile findByAuthUuid(String authUuid);

    boolean existsByNickname(String nickname);

    UserProfile findByNickname(String nickname);

    /*
     *   isLeader가 false 이면 처음으로 만족시킨 데이터가 나오는지 에러가 발생하는지
     * */
    Optional<UserProfile> findByTeamIdAndIsLeader(int teamId, boolean isLeader);

    List<UserProfile> findByTeamId(int teamId);

    @Query("SELECT new com.mongddangnaeddang.UTRServer.team.db.mapper.TeamMemberCountMapper( u.teamId, count(u)) FROM UserProfile u WHERE u.teamId IN :teamIds GROUP BY u.teamId")
    List<TeamMemberCountMapper> countByTeamIds(@Param("teamIds") List<Integer> teamIds);

    int countByTeamId(int teamId);
}

package com.mongddangnaeddang.MNServer.notification.repository;


import com.mongddangnaeddang.MNServer.notification.entity.TeamNotification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.ArrayList;

public interface TeamNotificationRepository extends JpaRepository<TeamNotification, Integer> {
    // 팀이 가지고 있는 notification 가져오기.
    ArrayList<TeamNotification> findByTeam1Id(int team1Id);

}

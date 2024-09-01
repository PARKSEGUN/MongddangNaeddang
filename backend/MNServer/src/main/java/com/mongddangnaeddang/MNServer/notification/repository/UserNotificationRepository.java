package com.mongddangnaeddang.MNServer.notification.repository;


import com.mongddangnaeddang.MNServer.notification.entity.TeamNotification;
import com.mongddangnaeddang.MNServer.notification.entity.UserNotification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.ArrayList;

public interface UserNotificationRepository extends JpaRepository<UserNotification, Integer> {  
    // 유저가 가지고 있는 notification 가져오기
    ArrayList<UserNotification> findByUser1UuidOrderByCreatedTimeDesc(String user1Uuid);

    void deleteAllByUser1Uuid(String profileUuid);
}

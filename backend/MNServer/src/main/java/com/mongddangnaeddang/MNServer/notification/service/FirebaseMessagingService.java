package com.mongddangnaeddang.MNServer.notification.service;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.mongddangnaeddang.MNServer.notification.dto.*;

import java.util.ArrayList;
import java.util.List;

public interface FirebaseMessagingService {
    public boolean sendRequestAlarm (IndividualNotification individualNotification);
    public boolean sendRootAlarm (GroupNotification groupNotification);
    public boolean createTeam(String teamName, String profileUuid);
    public boolean subscribeToTeam(TeamDTO team) throws FirebaseMessagingException;
    public boolean unsubscribeFromTeam(TeamDTO team) throws FirebaseMessagingException;
    public boolean deleteTeam(String teamName, String fcmToken);

    public boolean test (TestDTO test);
    public ArrayList<NotifData> getNotificationData(UserDto user);
    public boolean sendBadgeAlarm(String authUuid, String badge);

    public boolean deleteAllNotificationData(UserDto user);
}


package com.mongddangnaeddang.MNServer.notification.service;


import com.google.firebase.FirebaseApp;
import com.google.firebase.messaging.*;
import com.mongddangnaeddang.MNServer.client.UTRClient;
import com.mongddangnaeddang.MNServer.notification.dto.*;
import com.mongddangnaeddang.MNServer.notification.entity.TeamNotification;
import com.mongddangnaeddang.MNServer.notification.entity.UserNotification;
import com.mongddangnaeddang.MNServer.notification.repository.TeamNotificationRepository;
import com.mongddangnaeddang.MNServer.notification.repository.UserNotificationRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.text.SimpleDateFormat;
import java.sql.Timestamp;

@Service
public class FirebaseMessagingServiceImpl implements FirebaseMessagingService{
    @Autowired
    private FirebaseMessaging firebaseMessaging;

    @Autowired
    private UserNotificationRepository unr;
    @Autowired
    private TeamNotificationRepository tnr;

    @Autowired
    private UTRClient uc;
    @Autowired
    private UserNotificationRepository userNotificationRepository;

    @Override
    public boolean sendRequestAlarm (IndividualNotification individualNotification){
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        Notification notification = Notification.builder()
                .setTitle(individualNotification.getTitle())
                .setBody(individualNotification.getContent())
                .build();

        Message message = Message.builder()
                .setToken(individualNotification.getToken())
                .setNotification(notification)
                .build();
        UserNotification notif = new UserNotification();
        notif.setTitle(individualNotification.getTitle());
        notif.setContent(individualNotification.getContent());
        notif.setUser2Uuid(individualNotification.getSenderUuid());
        notif.setUser2Name(individualNotification.getSender());
        notif.setUser1Uuid(individualNotification.getReceiverUuid());
        notif.setUser1Name(individualNotification.getReceiver());
        notif.setCreatedTime(timestamp);
        System.out.println("Receiver : " + individualNotification.getReceiver());
        System.out.println(individualNotification.getToken());
        unr.save(notif);
        try{
            firebaseMessaging.send(message);
            return true;
        }catch(FirebaseMessagingException e){
            e.printStackTrace();
            return false;


        }
    }

    @Override
    public boolean sendRootAlarm (GroupNotification groupNotification){
        // teamId == topic 기반으로 보내기.
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        Notification notification = Notification.builder()
                .setTitle(groupNotification.getTitle())
                .setBody(groupNotification.getContent())
                .build();
        System.out.println(groupNotification.toString());
//        System.out.println("Token : " + groupNotification.getToken());
        Message message = Message.builder()
                .setToken(groupNotification.getToken())
                .setNotification(notification)
                .build();

        UserNotification notif = new UserNotification();
        notif.setTitle(groupNotification.getTitle());
        notif.setContent(groupNotification.getContent());
        //i11a802.p.ssafy.io
        notif.setUser1Uuid(groupNotification.getUserUuid());
        notif.setUser1Name(groupNotification.getUserName());
        notif.setUser2Uuid("server");
        notif.setUser2Name("server");

        notif.setCreatedTime(timestamp);
        unr.save(notif);
        try{
            firebaseMessaging.send(message);
            return true;
        }catch(FirebaseMessagingException e){
            e.printStackTrace();
            return false;


        }
    }

    @Override
    public boolean createTeam(String teamName, String profileUuid) {
        // 팀 생성, 팀 가입시에, teamName와 user FCMTOKEN을 받아, 토큰 구독
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        IndividualNotification in = new IndividualNotification();
        String title = "팀 생성";
        StringBuilder sb = new StringBuilder();
        sb.append(teamName);
        sb.append("가 생성되었습니다");
        String content = sb.toString();
//        UserAlarmDto userAlarmDto = uc.getNickNameResponse(profileUuid);
        UserAuthUuidResponse userAlarmDto = uc.getUserAuthUuidResponse(profileUuid);
        // 3. individualNotification에 set
        in.setTitle(title);
        in.setContent(content);
        in.setSender("server");
        in.setReceiver(profileUuid);
        in.setToken(userAlarmDto.getToken());

        Notification notification = Notification.builder()
                .setTitle(in.getTitle())
                .setBody(in.getContent())
                .build();

        Message message = Message.builder()
                .setToken(in.getToken())
                .setNotification(notification)
                .build();
        UserNotification notif = new UserNotification();
        notif.setTitle(in.getTitle());
        notif.setContent(in.getContent());
        notif.setUser2Uuid(in.getSender());
        notif.setUser1Uuid(in.getReceiver());
        notif.setUser2Name("server");
        notif.setUser1Name(userAlarmDto.getNickName());
        notif.setCreatedTime(timestamp);
        unr.save(notif);
        try {
            // 1. 팀 추가
//            TopicManagementResponse response = FirebaseMessaging.getInstance(FirebaseApp.getInstance("my-app"))
//                    .subscribeToTopic(Collections.singletonList(in.getToken()), teamName);

            // 2. teamDTO에 들어있는 유저 아이디(팀 가입 수락 했을때)로 보내기
            firebaseMessaging.send(message);

            return true;
        }catch (FirebaseMessagingException e){
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean subscribeToTeam(TeamDTO team) {
        // 팀 생성, 팀 가입시에, teamId와 user FCMTOKEN을 받아, 토큰 구독
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        IndividualNotification in = new IndividualNotification();
        String title = "팀 합류";
        StringBuilder sb = new StringBuilder();
        sb.append(team.getAuth2Name());
        sb.append("님이 ");
        sb.append(team.getTeamName());
        sb.append("에 합류하였습니다");
        String content = sb.toString();

        // 3. individualNotification에 set
        in.setTitle(title);
        in.setContent(content);
        in.setSender(team.getAuth2Uuid());
        in.setReceiver(team.getAuth1Uuid());
        in.setToken(team.getAuth1Token());

        Notification notification = Notification.builder()
                .setTitle(in.getTitle())
                .setBody(in.getContent())
                .build();
        Message message = Message.builder()
                .setToken(in.getToken())
                .setNotification(notification)
                .build();

        System.out.println(in.getToken());
        UserNotification notif = new UserNotification();
        notif.setTitle(in.getTitle());
        notif.setContent(in.getContent());
        notif.setUser2Uuid(in.getSender());
        notif.setUser1Uuid(in.getReceiver());
        notif.setCreatedTime(timestamp);
        notif.setUser1Name(team.getAuth1Name());
        notif.setUser2Name(team.getAuth2Name());
        System.out.println(notif.toString());
        unr.save(notif);
        try {
            // 1. 팀 추가
//            TopicManagementResponse response = FirebaseMessaging.getInstance(FirebaseApp.getInstance("my-app"))
//                    .subscribeToTopic(Collections.singletonList(team.getAuth2Token()), team.getTeamName());
            // 2. teamDTO에 들어있는 유저 아이디(팀 가입 수락 했을때)로 보내기
            firebaseMessaging.send(message);
            return true;
        }catch (FirebaseMessagingException e){
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean unsubscribeFromTeam(TeamDTO team) {
        // 팀 탈퇴시에, teamId와 user FCMTOKEN을 받아, 토큰 구독 해제
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        IndividualNotification in = new IndividualNotification();
        String title = "팀 탈퇴";
        StringBuilder sb = new StringBuilder();
        sb.append(team.getAuth2Name());
        sb.append(" 가 탈퇴 하였습니다");
        String content = sb.toString();

        // 3. individualNotification에 set
        in.setTitle(title);
        in.setContent(content);
        in.setSender(team.getAuth2Uuid());
        in.setReceiver(team.getAuth1Uuid());
        in.setToken(team.getAuth1Token());

        Notification notification = Notification.builder()
                .setTitle(in.getTitle())
                .setBody(in.getContent())
                .build();
        System.out.println(team.toString());
        Message message = Message.builder()
                .setToken(in.getToken())
                .setNotification(notification)
                .build();
        UserNotification notif = new UserNotification();
        notif.setTitle(in.getTitle());
        notif.setContent(in.getContent());
        notif.setUser2Uuid(in.getSender());
        notif.setUser1Uuid(in.getReceiver());
        notif.setUser1Name(team.getAuth1Name());
        notif.setUser2Name(team.getAuth2Name());
        notif.setCreatedTime(timestamp);
        unr.save(notif);
        try {
//            TopicManagementResponse response = FirebaseMessaging.getInstance(FirebaseApp.getInstance("my-app"))
//                    .unsubscribeFromTopic(Collections.singletonList(team.getAuth2Token()), team.getTeamName());
            firebaseMessaging.send(message);
            return true;
        }catch (FirebaseMessagingException e){

            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteTeam(String teamName, String fcmToken) {
        // 팀 해체시에, teamId와 팀에 소속된 user FCMTOKEN을 받아, 토큰 구독 해제
        return true;
//        try {
//            TopicManagementResponse response = FirebaseMessaging.getInstance(FirebaseApp.getInstance("my-app"))
//                    .unsubscribeFromTopic(Collections.singletonList(fcmToken), teamName);
//            return true;
//        }catch (FirebaseMessagingException e){
//
//            e.printStackTrace();
//            return false;
//        }
    }

    @Override
    public boolean test(TestDTO test) {

        // teamId == topic 기반으로 보내기.
        Notification notification = Notification.builder()
                .setTitle(test.getTitle())
                .setBody(test.getContent())
                .build();

        Message message = Message.builder()
                .setTopic(test.getTeamId())
                .setNotification(notification)
                .build();
        try{
            firebaseMessaging.send(message);
            return true;
        }catch(FirebaseMessagingException e){
            e.printStackTrace();
            return false;


        }
    }

    @Override
    public ArrayList<NotifData> getNotificationData(UserDto user) {
        // 유저 개인 알람 리스트 가져오기
        ArrayList<UserNotification> userNotif = unr.findByUser1UuidOrderByCreatedTimeDesc(user.getProfileUuid());
        // 팀 알람 리스트 가져오기
        ArrayList<TeamNotification> teamNotif = tnr.findByTeam1Id(user.getTeamId());

        // 2개 데이터 합치기
        // java stream
        ArrayList<NotifData> notificationList = new ArrayList<>();
        //    private String profileUuid;
        //    private String teamId;
        //    private String title;
        //    private String content;
        //    private String createdAt;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        // 유저 알람 데이터 적재
        for (int i =0; i< userNotif.size(); i++){

            UserNotification cur = userNotif.get(i);
            NotifData temp = new NotifData();
            temp.setUser1Name(cur.getUser1Name()); // sender
            temp.setUser2Name(cur.getUser2Name()); // receiver
            temp.setUser1Uuid(cur.getUser1Uuid());
            temp.setUser2Uuid(cur.getUser2Uuid());
            temp.setTeamId(user.getTeamId()); // 일단 저장하지만 쓰지 않음.
            temp.setTeamName(uc.getTeamName(user.getTeamId()));
            temp.setTitle(cur.getTitle());
            temp.setContent(cur.getContent());
            temp.setCreatedAt(sdf.format(cur.getCreatedTime()));
            System.out.println(temp.toString());
            notificationList.add(temp);
        }
        // 유저가 속한 팀 알람 데이터 적재. , 땅 뺏기.
        for (int i =0; i< teamNotif.size(); i++){
            TeamNotification cur = teamNotif.get(i);
            NotifData temp = new NotifData();
            temp.setUser1Name(" "); // null
            temp.setUser2Name(" "); // null
            temp.setUser1Uuid(" ");
            temp.setUser2Uuid(" ");

            temp.setTeamId(user.getTeamId());
            temp.setTeamName(uc.getTeamName(user.getTeamId()));
            temp.setTitle(cur.getTitle());
            temp.setContent(cur.getContent());
            if (cur.getCreatedTime() != null){
                temp.setCreatedAt(sdf.format(cur.getCreatedTime()));
            }

            notificationList.add(temp);

        }
        return notificationList;

    }

    @Override
    public boolean sendBadgeAlarm(String authUuid, String badge) {
        // Map 서버에서, 매개변수를 넘겨주면, badge 알람 생성후 사용자에게 보내주기
//        UserAlarmDto userAlarmDto = uc.getNickNameResponse(authUuid);
        UserAuthUuidResponse userAlarmDto = uc.getUserAuthUuidResponse(authUuid);
        String token = userAlarmDto.getToken();
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        // 팀 생성, 팀 가입시에, teamId와 user FCMTOKEN을 받아, 토큰 구독
        IndividualNotification in = new IndividualNotification();
        String title = "뱃지 획득";
        StringBuilder sb = new StringBuilder();
        sb.append("축하드립니다.");
        sb.append(badge);
        sb.append("를 얻었습니다.");
        String content = sb.toString();

        // 3. individualNotification에 set
        in.setTitle(title);
        in.setContent(content);
        in.setSender("server");
        in.setReceiver(userAlarmDto.getNickName());
        in.setSenderUuid("server");
        in.setReceiverUuid(authUuid);
        in.setToken(token);

        Notification notification = Notification.builder()
                .setTitle(in.getTitle())
                .setBody(in.getContent())
                .build();

        Message message = Message.builder()
                .setToken(in.getToken())
                .setNotification(notification)
                .build();

        UserNotification notif = new UserNotification();
        notif.setTitle(in.getTitle());
        notif.setContent(in.getContent());
        notif.setUser1Uuid(in.getReceiverUuid());
        notif.setUser2Uuid(in.getSenderUuid());
        notif.setUser1Name(in.getReceiver());
        notif.setUser2Name(in.getSender());
        notif.setCreatedTime(timestamp);
        unr.save(notif);

        try{
            firebaseMessaging.send(message);
            return true;
        }catch(FirebaseMessagingException e){
            e.printStackTrace();
            return false;

        }

    }

    @Transactional
    @Override
    public boolean deleteAllNotificationData(UserDto user) {
        // userData 전체 삭제
        userNotificationRepository.deleteAllByUser1Uuid(user.getProfileUuid());
        return true;
    }


}

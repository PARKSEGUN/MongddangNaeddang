package com.mongddangnaeddang.MNServer.notification.controller;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.mongddangnaeddang.MNServer.client.UTRClient;
import com.mongddangnaeddang.MNServer.notification.dto.*;
import com.mongddangnaeddang.MNServer.notification.service.FirebaseMessagingService;
import feign.Response;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

@RestController
@RequestMapping("/api/notification")
@Tag(name = "Notification API", description = " 알람 서버 ")
public class NotificationController {
    @Autowired
    FirebaseMessagingService fms;
    @Autowired
    private FirebaseMessaging firebaseMessaging;

    @Autowired
    private UTRClient uc;

    // Front 통신
    @PostMapping("/friend")
    @Operation(summary = "친구 요청", description = "친구 요청")
    public ResponseEntity<?> sendFriendRequestAlarm(@RequestBody IndividualNotification individualNotification) {
        // client에서 바로 Notification에 오는 알람.
        // 1. user에서 fcmToken 받아오기
        UserAlarmDto receiverData = uc.getNickNameResponse(individualNotification.getReceiver());
        UserAuthUuidResponse senderData = uc.getUserAuthUuidResponse(individualNotification.getSender());
        // 2. 알람 템플릿 작성
        String title = "친구 요청";

        StringBuilder sb = new StringBuilder();
        sb.append(senderData.getNickName());

        sb.append(" 친구요청을 보냈습니다.");
        String content = sb.toString();


        // 2-1. sender, receiver의 진짜 nickname 받아오기.


        // 3. individualNotification에 set
        individualNotification.setTitle(title);
        individualNotification.setContent(content);
        individualNotification.setToken(receiverData.getToken());
        individualNotification.setReceiverUuid(receiverData.getAuthUuid());
        individualNotification.setSenderUuid(individualNotification.getSender());
        individualNotification.setSender(senderData.getNickName());
        System.out.println(individualNotification.toString());
        boolean notif_res = fms.sendRequestAlarm(individualNotification);
        ResponseEntity<String> res = null;
        if (notif_res){
            res = new ResponseEntity<>("send alarm success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("send alarm failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }

    @PostMapping("/team")
    @Operation(summary = "팀 가입 요청", description = "팀 가입 요청")
    public ResponseEntity<?> sendTeamRequestAlarm(@RequestBody IndividualNotification individualNotification) {
        String title = "팀 가입 요청";
        // 1. user에서 token, nickName 받아오기
        UserAlarmDto receiverData = uc.getNickNameResponse(individualNotification.getReceiver());
        UserAlarmDto senderData = uc.getNickNameResponse(individualNotification.getSender());
        StringBuilder sb = new StringBuilder();
        sb.append(individualNotification.getSender());
        sb.append("가 ");
        sb.append("팀 가입 요청을 보냈습니다.");
        String content = sb.toString();

        // 3. individualNotification에 set
        individualNotification.setTitle(title);
        individualNotification.setContent(content);
        individualNotification.setToken(receiverData.getToken());
        individualNotification.setReceiverUuid(receiverData.getAuthUuid());
        individualNotification.setSenderUuid(senderData.getAuthUuid());
        boolean notif_res = fms.sendRequestAlarm(individualNotification);

        ResponseEntity<String> res = null;
        if (notif_res){
            res = new ResponseEntity<>("send alarm success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("send alarm failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }

    @PostMapping("/acquire")
    @Operation(summary = "유저에 대한 모든 알람 리턴 ", description = "유저에 대한 모든 알람 리턴")
    public ResponseEntity<?> acquireNotification(@RequestBody UserDto user) throws FirebaseMessagingException {
        // 팀 모든 데이터 가져오기
        // return : title, content, createdAt

        ArrayList<NotifData> notifData = fms.getNotificationData(user);
        ResponseEntity<ArrayList<NotifData>> res = null;
        if (!notifData.isEmpty()){
            res = new ResponseEntity<>(notifData, HttpStatus.OK);
        }else {
            res = new ResponseEntity<>(notifData, HttpStatus.NO_CONTENT);
        }
        return res;
    }


    @DeleteMapping("/deleteall")
    @Operation(summary = "유저에 대한 모든 알람 삭제 ", description = "유저에 대한 모든 알람 삭제")
    public ResponseEntity<?> deleteAllNotification(@RequestBody UserDto user) throws FirebaseMessagingException {
        // 팀 모든 데이터 가져오기
        // return : title, content, createdAt

        boolean resAction = fms.deleteAllNotificationData(user);
        ResponseEntity<String> res = null;
        if (resAction){
            res = new ResponseEntity<>("알람이 삭제되었습니다.", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("알람이 삭제 되지 않았습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }

    @DeleteMapping("/delete")
    @Operation(summary = "유저에 대한 특정 알람 삭제 ", description = "유저에 대한 특정 알람 삭제")
    public ResponseEntity<?> deleteNotification(@RequestBody UserDto user) throws FirebaseMessagingException {
        // 팀 모든 데이터 가져오기
        // return : title, content, createdAt

        boolean resAction = fms.deleteAllNotificationData(user);
        ResponseEntity<String> res = null;
        if (resAction){
            res = new ResponseEntity<>("알람이 삭제되었습니다.", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("알람이 삭제 되지 않았습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }

    // backend 통신

    @PostMapping("/friendresult")
    @Operation(summary = "친구 요청에 대한 응답 알람", description = "친구 요청에 대한 응답 알람")
    public ResponseEntity<?> sendFriendResultAlarm(@RequestBody IndividualNotification individualNotification) {
        // friend에 결과가 간후, friend에서 오는 알람.
        // 알람 타입 -> 수락 , 추후 확장가능 하게 작성.

        // 1. 알람 템플릿 작성
        String title = "친구 수락";

        StringBuilder sb = new StringBuilder();
        sb.append(individualNotification.getSender());
        sb.append("와");
        sb.append("친구가 되었습니다.");
        String content = sb.toString();

        // 2. individualNotification에 set
        individualNotification.setTitle(title);
        individualNotification.setContent(content);
        boolean notif_res = fms.sendRequestAlarm(individualNotification);
        ResponseEntity<String> res = null;
        if (notif_res){
            res = new ResponseEntity<>("send alarm success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("send alarm failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }



    @PostMapping("/steal")
    @Operation(summary = "땅 약탈 알람 ", description = "땅 약탈 알람 수행")
    public ResponseEntity<?> sendRootAlarm(@RequestBody GroupNotification notificationMessage) {
        // steal은 topic이 팀네임으로 저장되어 있어서, 추가 정보 필요없음.

        boolean notif_res = fms.sendRootAlarm(notificationMessage);
        ResponseEntity<String> res = null;
        if (notif_res){
            res = new ResponseEntity<>("send alarm success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("send alarm failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }

    @PostMapping("/badge")
    @Operation(summary = "뱃지 알람", description = "뱃지 달성 알람 유저에게 보내기.")
    public ResponseEntity<?> sendBadgeAlarm(){
        // 흠.. 뱃지 달성 알람..?
        return null;
    }

    @PostMapping("/join")
    @Operation(summary = "팀 합류", description = "팀 합류 했을 때, ")
    public ResponseEntity<?> subscribeToTeam(@RequestBody TeamDTO joinNotif) throws FirebaseMessagingException {
        // 팀 구
        // 새로 합류한 팀원에겐 알람 보내기
        boolean notifRes = fms.subscribeToTeam(joinNotif);
        ResponseEntity<String> res = null;
        if (notifRes){
            res = new ResponseEntity<>("topic subscribe success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("topic subscribe fail", HttpStatus.OK);
        }
        return res;
    }

    @GetMapping("/teamcreate")
    @Operation(summary = "팀 생성 알람", description = "팀 생성 알람 ")
    public void createTeam(@RequestParam("teamName") String teamName , @RequestParam("profileUuid") String profileUuid) throws FirebaseMessagingException {
        // 팀 구독
        // 새로 합류한 팀원에겐 알람 보내기
        boolean notifRes = fms.createTeam(teamName, profileUuid);;
        ResponseEntity<String> res = null;
        if (notifRes){
            res = new ResponseEntity<>("topic subscribe success", HttpStatus.OK);
            System.out.println( "알람 성공.");
        }else {
            res = new ResponseEntity<>("topic subscribe fail", HttpStatus.OK);
        }
        return;
    }

    @PostMapping("/leave")
    @Operation(summary = "팀 탈퇴", description = "팀 탈퇴 했을 때, ")
    public ResponseEntity<?> unsubscribeFromTeam(@RequestBody TeamDTO deleteNotif) throws FirebaseMessagingException {
        // 팀 구독
        // 탈퇴한 팀의 리더에게 보내기.

        boolean notifRes = fms.unsubscribeFromTeam(deleteNotif);
        ResponseEntity<String> res = null;
        if (notifRes){
            res = new ResponseEntity<>("topic unsubscribe success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("topic unsubscribe fail", HttpStatus.OK);
        }
        return res;
    }

    @GetMapping("/delete")
    @Operation(summary = "팀 해체", description = "팀 해체 했을 때, 토큰에서 팀 제거 및 알람 보내기 ")
    public ResponseEntity<?> deleteTeam(@RequestParam("teamName") String teamName, @RequestParam("fcmToken") String fcmToken) throws FirebaseMessagingException {
        // 팀 구독 해제
        boolean notifRes = fms.deleteTeam(teamName,fcmToken);
        ResponseEntity<String> res = null;
        if (notifRes){
            res = new ResponseEntity<>("topic unsubscribe success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("topic unsubscribe fail", HttpStatus.OK);
        }
        return res;
    }



    @PostMapping("/test")
    @Operation(summary = "팀 전달 알람 테스트 ", description = "땅 약탈 알람 수행 하기전 테스트.")
    public ResponseEntity<?> sendTest(@RequestBody TestDTO test) {
        System.out.println("hi I'm here die");
        boolean notif_res = fms.test(test);
        ResponseEntity<String> res = null;
        if (notif_res){
            res = new ResponseEntity<>("send alarm success", HttpStatus.OK);
        }else {
            res = new ResponseEntity<>("send alarm failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return res;
    }


}

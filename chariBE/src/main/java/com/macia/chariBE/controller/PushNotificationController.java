package com.macia.chariBE.controller;


import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.model.PushNotification;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.IJwtUserRepository;
import com.macia.chariBE.repository.IPushNotificationRepository;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/push_notifications")
public class PushNotificationController {

    @Autowired
    PushNotificationService pushNotificationService;

    @Autowired
    IJwtUserRepository IJwtUserRepository;

    @Autowired
    IPushNotificationRepository repo;

    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(repo.findAll().stream()
                .sorted(Comparator.comparing(PushNotification::getNOF_ID))
                .collect(Collectors.toList()));
    }

    @PostMapping()
    public ResponseEntity<?> savePushNotification(@RequestBody PushNotification notification) {
        repo.save(notification);
        return ResponseEntity.ok().body(repo.findAll().stream()
                .sorted(Comparator.comparing(PushNotification::getNOF_ID))
                .collect(Collectors.toList()));
    }

    /*==========================================================================================*/
    @PostMapping("/topic")
    public String pushNotificationWithoutDataToTopic(@RequestBody NotificationObject request) {
        pushNotificationService.sendMessageWithoutData(request);
        return "Notification has been sent";
    }

    @PostMapping("/username/{usn}")
    public  ResponseEntity<?> pushNotificationWithoutDataToDeviceLoggedByUser(
            @PathVariable(value = "usn") String username,
            @RequestBody NotificationObject request) {
        JwtUser appUser = IJwtUserRepository.findByUsername(username);
        JSONObject jso = new JSONObject();
        if(appUser!=null){
            if(appUser.getFcmToken()!=null){
                request.setToken(appUser.getFcmToken());
                pushNotificationService.sendMessageToToken(request);
                jso.put("errorCode", 0);
                jso.put("data", appUser);
                jso.put("message", "Gửi tin nhắn đến user:"+username+" thành công !");
                return new ResponseEntity<>(jso, HttpStatus.OK);
            }else{
                jso.put("errorCode", 2);
                jso.put("data", "");
                jso.put("message", "User: "+username+ " chưa đăng nhập trên bất kỳ thiết bị nào!");
                return new ResponseEntity<>(jso, HttpStatus.OK);
            }
        }else{
            jso.put("errorCode", 1);
            jso.put("data", "");
            jso.put("message", "Không thể tìm thấy người dùng với username: "+username+ " !");
            return new ResponseEntity<>(jso, HttpStatus.OK);
        }
    }
}
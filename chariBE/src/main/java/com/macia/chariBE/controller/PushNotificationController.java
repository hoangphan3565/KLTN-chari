package com.macia.chariBE.controller;


import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.model.PushNotification;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.JwtUserRepository;
import com.macia.chariBE.repository.PushNotificationRepository;
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
    JwtUserRepository jwtUserRepository;

    @Autowired
    PushNotificationRepository repo;

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
        JwtUser appUser = jwtUserRepository.findByUsername(username);
        JSONObject jo = new JSONObject();
        if(appUser!=null){
            if(appUser.getFcmToken()!=null){
                request.setToken(appUser.getFcmToken());
                pushNotificationService.sendMessageToToken(request);
                jo.put("errorCode", 0);
                jo.put("data", appUser);
                jo.put("message", "Gửi tin nhắn đến user:"+username+" thành công !");
                return new ResponseEntity<>(jo, HttpStatus.OK);
            }else{
                jo.put("errorCode", 2);
                jo.put("data", "");
                jo.put("message", "User: "+username+ " chưa đăng nhập trên bất kỳ thiết bị nào!");
                return new ResponseEntity<>(jo, HttpStatus.OK);
            }
        }else{
            jo.put("errorCode", 1);
            jo.put("data", "");
            jo.put("message", "Không thể tìm thấy người dùng với username: "+username+ " !");
            return new ResponseEntity<>(jo, HttpStatus.OK);
        }
    }
}
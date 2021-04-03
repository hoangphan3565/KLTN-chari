package com.macia.charitysystem.controller;


import com.macia.charitysystem.model.JwtUser;
import com.macia.charitysystem.pushnotification.NotificationObject;
import com.macia.charitysystem.pushnotification.PushNotificationService;
import com.macia.charitysystem.repository.JwtUserRepository;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/notification")
public class PushNotificationController {

    @Autowired
    PushNotificationService pushNotificationService;

    @Autowired
    JwtUserRepository jwtUserRepository;

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
                return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
            }else{
                jo.put("errorCode", 2);
                jo.put("data", "");
                jo.put("message", "User: "+username+ " chưa đăng nhập trên bất kỳ thiết bị nào!");
                return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
            }
        }else{
            jo.put("errorCode", 1);
            jo.put("data", "");
            jo.put("message", "Không thể tìm thấy người dùng với username: "+username+ " !");
            return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
        }
    }
    /*************************************************************************************************888*/

    @PostMapping("/data")
    public String pushDataNotification(@RequestBody NotificationObject request) {
        pushNotificationService.sendMessage(request);
        return "Notification has been sent";
    }

    @PostMapping("/data/customdatawithtopic")
    public String pushDataNotificationCustom(@RequestBody NotificationObject request) {
        pushNotificationService.sendMessageCustomDataWithTopic(request);
        return "Notification has been sent";
    }
    @PostMapping("/data/customdatawithtopicjson")
    public String pushDataNotificationCustomWithSpecificJson(@RequestBody NotificationObject request) {
        pushNotificationService.sendMessageCustomDataWithTopicWithSpecificJson(request);
        return "Notification has been sent";
    }

    public void pushAutomaticNotification(){
        NotificationObject request = new NotificationObject();
        request.setTopic("global");
        pushNotificationService.sendMessageCustomDataWithTopicWithSpecificJson(request);
    }
}
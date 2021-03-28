package com.macia.charitysystem.controller;


import com.macia.charitysystem.pushnotification.NotificationObject;
import com.macia.charitysystem.pushnotification.PushNotificationService;
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

    @PostMapping("/topic")
    public String sendNotification(@RequestBody NotificationObject request) {
        pushNotificationService.sendPushNotificationWithoutData(request);
        return "Notification has been sent";
    }
    /*************************************************************************************************888*/

    @PostMapping("/token")
    public String sendTokenNotification(@RequestBody NotificationObject request) {
        pushNotificationService.sendPushNotificationToToken(request);
        return "Notification has been sent";
    }

    @PostMapping("/data")
    public String sendDataNotification(@RequestBody NotificationObject request) {
        pushNotificationService.sendPushNotification(request);
        return "Notification has been sent";
    }

    @PostMapping("/data/customdatawithtopic")
    public String sendDataNotificationCustom(@RequestBody NotificationObject request) {
        pushNotificationService.sendPushNotificationCustomDataWithTopic(request);
        return "Notification has been sent";
    }
    @PostMapping("/data/customdatawithtopicjson")
    public String sendDataNotificationCustomWithSpecificJson(@RequestBody NotificationObject request) {
        pushNotificationService.sendPushNotificationCustomDataWithTopicWithSpecificJson(request);
        return "Notification has been sent";
    }

    public void sendAutomaticNotification(){
        NotificationObject request = new NotificationObject();
        request.setTopic("global");
        pushNotificationService.sendPushNotificationCustomDataWithTopicWithSpecificJson(request);
    }
}
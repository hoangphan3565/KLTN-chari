package com.macia.charitysystem.pushnotification;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
public class PushNotificationService {

    final private Logger logger = LoggerFactory.getLogger(PushNotificationService.class);

    @Autowired
    FCMService fcmService;


    public void sendMessageWithoutData(NotificationObject request) {
        try {
            fcmService.sendMessageWithoutData(request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }


    public void sendMessageToToken(NotificationObject request) {
        try {
            fcmService.sendMessageToToken(request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    public void sendMessage(NotificationObject request) {
        try {
            fcmService.sendMessage(getSamplePayloadData(), request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    public void sendMessageCustomDataWithTopic(NotificationObject request) {
        try {
            fcmService.sendMessageCustomDataWithTopic(getSamplePayloadDataCustom(), request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    public void sendMessageCustomDataWithTopicWithSpecificJson(NotificationObject request) {
        try {
            fcmService.sendMessageCustomDataWithTopic(getSamplePayloadDataWithSpecificJsonFormat(), request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }




    private Map<String, String> getSamplePayloadData() {
        Map<String, String> pushData = new HashMap<>();
        pushData.put("title", "Tiêu đề....");
        pushData.put("message", "project_added....");
        pushData.put("topic", "Tin nhắn....");
        pushData.put("image", "https://ktktlaocai.edu.vn/wp-content/uploads/2019/10/tre-em-vung-cao-kho-khan-1.jpg");
        pushData.put("timestamp", String.valueOf(LocalDateTime.now()));
        pushData.put("article_data", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.");

        return pushData;
    }


    private Map<String, String> getSamplePayloadDataCustom() {
        Map<String, String> pushData = new HashMap<>();
        pushData.put("title", "Notification for pending work-custom");
        pushData.put("message", "pls complete your pending task immediately-custom");
        pushData.put("image", "https://ktktlaocai.edu.vn/wp-content/uploads/2019/10/tre-em-vung-cao-kho-khan-1.jpg");
        pushData.put("timestamp", String.valueOf(new Date()));
        pushData.put("article_data", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.");
        return pushData;
    }


    private Map<String, String> getSamplePayloadDataWithSpecificJsonFormat() {
        Map<String, String> pushData = new HashMap<>();
        Map<String, String> data = new HashMap<>();
        ArrayList<Map<String, String>> payload = new ArrayList<>();
        Map<String, String> article_data = new HashMap<>();

        pushData.put("title", "jsonformat");
        pushData.put("message", "itsworkingkudussssssssssssssssssssssssssssssssssss");
        pushData.put("image", "qqq");
        pushData.put("timestamp", "fefe");
        article_data.put("article_data", "ffff");
        payload.add(article_data);
        pushData.put("payload", String.valueOf(payload));
        data.put("data", String.valueOf(pushData));
        return data;

        /*getPreconfiguredMessageBuilderCustomDataWithTopic will get some issue to generate notification as
        * data.get("title") wont give us title as its mapped inside data
        * */
    }
}
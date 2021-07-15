package com.macia.chariBE.pushnotification;

import com.google.firebase.messaging.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Service
public class FCMService {

    final private Logger logger = LoggerFactory.getLogger(FCMService.class);

    public void sendMessageWithoutData(NotificationObject request)
            throws InterruptedException, ExecutionException {
        Message message = getPreconfiguredMessageWithoutData(request);
        String response = sendAndGetResponse(message);
        logger.info("Sent message without data. Topic: " + request.getTopic() + ", " + response);
    }

    public void sendMessageToToken(NotificationObject request)
            throws InterruptedException, ExecutionException {
        Message message = getPreconfiguredMessageToToken(request);
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String jsonOutput = gson.toJson(message);
        String response = sendAndGetResponse(message);
        logger.info("Sent message to token. Device token: " + request.getToken() + ", " + response+ " msg "+jsonOutput);
    }

//    public void sendMessageTopicAndToken(NotificationObject request)
//            throws InterruptedException, ExecutionException {
//        Message message = getPreconfiguredMessageToTopicAndToken(request);
//        String response = sendAndGetResponse(message);
//        logger.info("Sent message to Topic: " + request.getTopic() + ", "+" Device token: " + request.getToken() + response);
//    }

    private String sendAndGetResponse(Message message) throws InterruptedException, ExecutionException {
        return FirebaseMessaging.getInstance().sendAsync(message).get();
    }

    private AndroidConfig getAndroidConfig(String topic) {
        return AndroidConfig.builder()
                .setTtl(Duration.ofMinutes(2).toMillis()).setCollapseKey(topic)
                .setPriority(AndroidConfig.Priority.HIGH)
                .setNotification(AndroidNotification.builder().setSound(NotificationParameter.SOUND.getValue())
                        .setColor(NotificationParameter.COLOR.getValue()).setTag(topic).build()).build();
    }

    private ApnsConfig getApnsConfig(String topic) {
        return ApnsConfig.builder()
                .setAps(Aps.builder().setCategory(topic).setThreadId(topic).build()).build();
    }

    private Message getPreconfiguredMessageToToken(NotificationObject request) {
        return getPreconfiguredMessageBuilder(request).setToken(request.getToken()).build();
    }

    private Message getPreconfiguredMessageWithoutData(NotificationObject request) {
        return getPreconfiguredMessageBuilder(request).setTopic(request.getTopic().toString()).build();
    }

    private Message getPreconfiguredMessageToTopicAndToken(NotificationObject request) {
        return getPreconfiguredMessageBuilder(request).setTopic(request.getTopic().toString()).setToken(request.getToken()).build();
    }


    private Message.Builder getPreconfiguredMessageBuilder(NotificationObject request) {
        AndroidConfig androidConfig = getAndroidConfig(request.getTopic().toString());
        ApnsConfig apnsConfig = getApnsConfig(request.getTopic().toString());
        return Message.builder()
                .setApnsConfig(apnsConfig).setAndroidConfig(androidConfig).setNotification(
                        Notification.builder().setTitle(request.getTitle()).setBody(request.getMessage()).build());
    }
}
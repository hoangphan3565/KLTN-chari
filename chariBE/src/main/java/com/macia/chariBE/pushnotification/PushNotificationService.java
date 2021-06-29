package com.macia.chariBE.pushnotification;
import com.macia.chariBE.model.DonatorNotification;
import com.macia.chariBE.model.PushNotification;
import com.macia.chariBE.repository.PushNotificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class PushNotificationService {

    final private Logger logger = LoggerFactory.getLogger(PushNotificationService.class);

    @Autowired
    FCMService fcmService;

    @Autowired
    private PushNotificationRepository repo;

    public String findAllIdAsString(){
        List<PushNotification> lsp = repo.findAll();
        StringBuilder s = new StringBuilder();
        for(PushNotification p:lsp){
            s.append(p.getNOF_ID()).append(" ");
        }
        return s.toString();
    }

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
}
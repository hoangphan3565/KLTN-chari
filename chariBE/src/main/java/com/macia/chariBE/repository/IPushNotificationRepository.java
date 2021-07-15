package com.macia.chariBE.repository;

import com.macia.chariBE.model.PushNotification;
import com.macia.chariBE.utility.ENotificationTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IPushNotificationRepository extends JpaRepository<PushNotification, Integer> {
    PushNotification findByTopic(ENotificationTopic topicName);
}

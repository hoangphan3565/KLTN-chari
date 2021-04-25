package com.macia.chariBE.repository;

import com.macia.chariBE.model.PushNotificationTopic;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PushNotificationTopicRepository extends JpaRepository<PushNotificationTopic, Integer> {
}

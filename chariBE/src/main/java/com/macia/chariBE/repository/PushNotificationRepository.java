package com.macia.chariBE.repository;

import com.macia.chariBE.model.PushNotification;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PushNotificationRepository extends JpaRepository<PushNotification, Integer> {
}

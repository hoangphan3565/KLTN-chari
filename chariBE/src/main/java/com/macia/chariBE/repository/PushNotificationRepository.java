package com.macia.chariBE.repository;

import com.macia.chariBE.model.PushNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PushNotificationRepository extends JpaRepository<PushNotification, Integer> {
}

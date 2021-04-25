package com.macia.chariBE.repository;

import com.macia.chariBE.model.DonatorNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonatorNotificationRepository  extends JpaRepository<DonatorNotification, Integer> {
}

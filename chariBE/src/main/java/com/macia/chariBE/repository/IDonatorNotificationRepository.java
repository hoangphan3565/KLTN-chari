package com.macia.chariBE.repository;

import com.macia.chariBE.model.DonatorNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IDonatorNotificationRepository extends JpaRepository<DonatorNotification, Integer> {
    List<DonatorNotification> findByReadFalse();
}

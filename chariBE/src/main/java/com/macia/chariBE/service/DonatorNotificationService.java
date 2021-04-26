package com.macia.chariBE.service;

import com.macia.chariBE.DTO.DonatorNotificationDTO;
import com.macia.chariBE.model.DonatorNotification;
import com.macia.chariBE.repository.DonatorNotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class DonatorNotificationService {
    @Autowired
    private DonatorNotificationRepository repo;

    @PersistenceContext
    private EntityManager em;

    public void save(DonatorNotification notification) {
        repo.saveAndFlush(notification);
    }

    public List<DonatorNotificationDTO> findDonatorNotificationByDonatorId(Integer donator_id) {
        try {
            TypedQuery<DonatorNotificationDTO> query = em.createNamedQuery("named.donator_notification.findByDonatorId", DonatorNotificationDTO.class);
            query.setParameter("dnt_id", donator_id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
}

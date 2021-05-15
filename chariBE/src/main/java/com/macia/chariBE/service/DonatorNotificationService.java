package com.macia.chariBE.service;

import com.macia.chariBE.model.Donator;
import com.macia.chariBE.model.DonatorNotification;
import com.macia.chariBE.repository.DonatorNotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.management.Notification;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDateTime;
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

    public List<DonatorNotification> findDonatorNotificationByDonatorId(Integer donator_id) {
        try {
            TypedQuery<DonatorNotification> query = em.createNamedQuery("named.donator_notification.findByDonatorId", DonatorNotification.class);
            query.setParameter("dnt_id", donator_id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    public void handleCloseProjectNotification(int project_id,int donator_id){
        try {
            TypedQuery<DonatorNotification> query = em.createNamedQuery("named.donator_notification.findClosedNotiByProjectIdAndDonatorId", DonatorNotification.class);
            query.setParameter("prj_id", project_id);
            query.setParameter("dnt_id", donator_id);
            DonatorNotification d = query.getSingleResult();
            d.setIs_handled(true);
            repo.saveAndFlush(d);
        } catch (NoResultException ignored) {
        }
    }
}

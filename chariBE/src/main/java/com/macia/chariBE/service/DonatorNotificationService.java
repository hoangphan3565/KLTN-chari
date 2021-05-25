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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
public class DonatorNotificationService {
    @Autowired
    private DonatorNotificationRepository repo;

    @Autowired
    private DonatorService donatorService;

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
            TypedQuery<DonatorNotification> query = em.createNamedQuery("named.donator_notification.findClosedNotificationByProjectIdAndDonatorId", DonatorNotification.class);
            query.setParameter("prj_id", project_id);
            query.setParameter("dnt_id", donator_id);
            DonatorNotification d = query.getSingleResult();
            d.setHandled(true);
            repo.saveAndFlush(d);
        } catch (NoResultException ignored) {
        }
    }

    public void handleAllMoneyOfClosedProjectOverSevenDay(){
        List<DonatorNotification> ldn;
        try {
            TypedQuery<DonatorNotification> query = em.createNamedQuery("named.donator_notification.findAllClosedAndUnHandledNotification", DonatorNotification.class);
            ldn = query.getResultList();
            for(DonatorNotification dn:ldn){
                if(ChronoUnit.DAYS.between(LocalDate.now(), dn.getCreate_time().toLocalDate())>7){
                    donatorService.moveMoney(dn.getProject_id(),dn.getDonator().getDNT_ID(),0, dn.getTotal_money());
                    dn.setHandled(true);
                }
            }
            repo.saveAll(ldn);
        } catch (NoResultException ignored) {
        }
    }

    public List<DonatorNotification> putReadUnreadNotification(Integer donator_id){
        List<DonatorNotification> ldn = repo.findByReadFalse();
        for(DonatorNotification dn:ldn){
            dn.setRead(true);
        }
        repo.saveAll(ldn);
        return ldn;
    }
    public boolean checkHaveNewNotificationUnread(Integer donator_id){
       return !repo.findByReadFalse().isEmpty(); //list thông báo chưa đọc rỗng -> đã đọc hết -> không có thông báo mới
    }
}

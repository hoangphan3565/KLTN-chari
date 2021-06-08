package com.macia.chariBE.service;

import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.DonatorNotificationRepository;
import com.macia.chariBE.repository.JwtUserRepository;
import com.macia.chariBE.repository.PushNotificationRepository;
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

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private PushNotificationRepository pushNotificationRepository;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private JwtUserRepository jwtUserRepository;

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
                if(ChronoUnit.DAYS.between(dn.getCreate_time().toLocalDate(),LocalDate.now())>7){
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

    public void saveAndPushNotificationToUser(PushNotification pn,Integer project_id) {
        NotificationObject no = new NotificationObject();
        no.setTitle(pn.getTitle());
        no.setMessage(pn.getMessage());
        no.setTopic(pn.getTopic());
        List<DonateActivity> listDA = this.donateActivityService.findDonateActivityByProjectID(project_id);
        for(DonateActivity da:listDA){
            JwtUser appUser = jwtUserRepository.findByUsername(da.getDonator().getPhoneNumber());
            if(da.getDonator().getDNT_ID()!=0){
                if(appUser.getFcmToken() != null){
                    no.setToken(appUser.getFcmToken());
                    pushNotificationService.sendMessageToToken(no);
                }
                this.save(DonatorNotification.builder().topic(pn.getTopic()).title(pn.getTitle())
                        .message(pn.getMessage()).create_time(LocalDateTime.now()).read(false).handled(false)
                        .total_money(donatorService.getTotalDonateMoneyOfDonatorByProjectId(project_id,da.getDonator().getDNT_ID()))
                        .donator(da.getDonator())
                        .project_id(project_id).build());
            }
        }
    }

    public void saveAndPushNotificationToAllUser(Integer id,String topic) {
        NotificationObject no = new NotificationObject();
        PushNotification pn = this.pushNotificationRepository.findByTopic(topic);
        no.setTitle(pn.getTitle());
        no.setMessage(pn.getMessage());
        no.setTopic(pn.getTopic());
        List<Donator> donators = this.donatorService.findAll();
        for(Donator d:donators){
            this.save(DonatorNotification.builder()
                    .topic(pn.getTopic()).title(pn.getTitle()).message(pn.getMessage())
                    .create_time(LocalDateTime.now()).read(false).handled(false)
                    .donator(d).project_id(id).build());
        }
        this.pushNotificationService.sendMessageWithoutData(no);
    }
}

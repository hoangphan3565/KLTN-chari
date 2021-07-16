package com.macia.chariBE.service;

import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.IDonatorNotificationRepository;
import com.macia.chariBE.repository.IJwtUserRepository;
import com.macia.chariBE.repository.IPushNotificationRepository;
import com.macia.chariBE.utility.ENotificationTopic;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DonatorNotificationService {
    @Autowired
    private IDonatorNotificationRepository repo;

    @Autowired
    private DonatorService donatorService;

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private IPushNotificationRepository pushNotificationRepository;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private IJwtUserRepository IJwtUserRepository;

    @Autowired
    private ProjectService projectService;

    public void save(DonatorNotification notification) {
        repo.saveAndFlush(notification);
    }


    public int countAllDonatorNotificationByDonatorIdAndTitle(Integer id, String skey) {
        try {
            TypedQuery<DonatorNotification> query = em.createNamedQuery("named.donator_notification.findByDonatorIdAndTitle", DonatorNotification.class);
            query.setParameter("dnt_id", id);
            if(skey.equals("*")){
                query.setParameter("skey", "%"+""+"%");
            }else{
                query.setParameter("skey", "%" + skey.toLowerCase() + "%");
            }
            return query.getResultList().size();
        } catch (NoResultException e) {
            return -1;
        }
    }

    public List<DonatorNotification>  findDonatorNotificationByDonatorIdAndTitlePageASizeB(Integer id, String skey, Integer a, Integer b) {
        try {
            TypedQuery<DonatorNotification> query = em.createNamedQuery("named.donator_notification.findByDonatorIdAndTitle", DonatorNotification.class)
                    .setFirstResult(a*b).setMaxResults(b);
            query.setParameter("dnt_id", id);
            if(skey.equals("*")){
                query.setParameter("skey", "%"+""+"%");
            }else{
                query.setParameter("skey", "%" + skey.toLowerCase() + "%");
            }
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
        Project project = projectService.findProjectById(project_id);
        no.setTitle(pn.getTitle());
        String msg = "Dự án '"+project.getProjectName()+"'"+pn.getMessage();
        no.setMessage(msg);
        no.setTopic(pn.getTopic());
        List<Donator> donatorsHaveDonate = new ArrayList<>();
        List<DonateActivity> listDA = this.donateActivityService.findDonateActivityByProjectID(project_id);
        for(DonateActivity da:listDA){
            JwtUser appUser = IJwtUserRepository.findByUsername(da.getDonator().getUsername());
            Donator donator = da.getDonator();
            donatorsHaveDonate.add(donator);
            if(donator.getDNT_ID()!=0 && donator.getFavoriteNotification()!=null){
                String notifications = donator.getFavoriteNotification();
                if(notifications.contains(pn.getNOF_ID().toString())){
                    if(appUser.getFcmToken() != null){
                        no.setToken(appUser.getFcmToken());
                        pushNotificationService.sendMessageToToken(no);
                    }
                    if(pn.getTopic().equals(ENotificationTopic.CLOSED)){
                        this.save(DonatorNotification.builder().topic(pn.getTopic()).title(pn.getTitle())
                                .message(msg).create_time(LocalDateTime.now()).read(false).handled(false)
                                .total_money(donatorService.getTotalDonateMoneyOfDonatorByProjectId(project_id,da.getDonator().getDNT_ID()))
                                .donator(da.getDonator()).project_id(project_id).project_image(project.getImageUrl()).build());
                    }else{
                        this.save(DonatorNotification.builder()
                                .topic(pn.getTopic()).title(pn.getTitle()).message(msg)
                                .create_time(LocalDateTime.now()).read(false).handled(false)
                                .donator(da.getDonator()).project_id(project_id).project_image(project.getImageUrl()).build());
                    }
                }
            }
        }
        List<Donator> donators = this.donatorService.findWhereHaveAccount().stream().filter(d->!donatorsHaveDonate.contains(d)).collect(Collectors.toList());
        for(Donator d:donators){
            JwtUser appUser = IJwtUserRepository.findByUsername(d.getUsername());
            if(d.getFavoriteProject().contains(project_id.toString())){
                if(d.getFavoriteNotification().contains(pn.getNOF_ID().toString())){
                    if(appUser.getFcmToken() != null){
                        no.setToken(appUser.getFcmToken());
                        pushNotificationService.sendMessageToToken(no);
                    }
                    this.save(DonatorNotification.builder()
                            .topic(pn.getTopic()).title(pn.getTitle()).message(msg)
                            .create_time(LocalDateTime.now()).read(false).handled(false)
                            .donator(d).project_id(project_id).project_image(projectService.getImageUrlOfProjectById(project_id)).build());
                }
            }
        }
    }


    public void saveAndPushNotificationToAllUser(Integer project_id, ENotificationTopic topic) {
        NotificationObject no = new NotificationObject();
        Project project = projectService.findProjectById(project_id);
        PushNotification pn = this.pushNotificationRepository.findByTopic(topic);
        String msg = "Dự án '"+project.getProjectName()+"'"+pn.getMessage();
        no.setTitle(pn.getTitle());
        no.setMessage(msg);
        no.setTopic(pn.getTopic());
        List<Donator> donators = this.donatorService.findWhereHaveAccount();
        for(Donator d:donators){
            if(d.getFavoriteNotification().contains(pn.getNOF_ID().toString())){
                this.save(DonatorNotification.builder()
                        .topic(pn.getTopic()).title(pn.getTitle()).message(msg)
                        .create_time(LocalDateTime.now()).read(false).handled(false)
                        .donator(d).project_id(project_id).project_image(projectService.getImageUrlOfProjectById(project_id)).build());
            }
        }
        this.pushNotificationService.sendMessageWithoutData(no);
    }
}

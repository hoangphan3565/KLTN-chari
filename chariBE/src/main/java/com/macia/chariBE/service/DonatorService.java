package com.macia.chariBE.service;

import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.IDonateDetailsRepository;
import com.macia.chariBE.repository.IDonatorRepository;
import com.macia.chariBE.repository.IPushNotificationRepository;
import com.macia.chariBE.utility.EDonateActivityStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class DonatorService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private IDonatorRepository donatorRepo;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private IDonateDetailsRepository IDonateDetailsRepository;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private DonateDetailsService donateDetailsService;

    @Autowired
    private IPushNotificationRepository IPushNotificationRepository;

    @Autowired
    private PushNotificationService pushNotificationService;

    public void save(Donator donator) {
        donatorRepo.saveAndFlush(donator);
    }

    public Donator findById(Integer id) {
        return donatorRepo.findById(id).orElseThrow();
    }

    public List<Donator> findAll(){
        TypedQuery<Donator> query = em.createNamedQuery("named.donator.findAll", Donator.class);
        return query.getResultList();
    }

    public List<Donator> findWhereHaveAccount(){
        TypedQuery<Donator> query = em.createNamedQuery("named.donator.findWhereHaveAccount", Donator.class);
        return query.getResultList();
    }

    public Donator findByUserName(Integer id){
        TypedQuery<Donator> query = em.createNamedQuery("named.donator.findById", Donator.class);
        query.setParameter("id",id);
        return query.getSingleResult();
    }


    public Donator findByUsername(String username) {
        try {
            return donatorRepo.findByUsername(username);
        } catch (NoResultException e) {
            return null;
        }
    }


    public Integer getDonatorIdByUsername(String s){
        Donator d = donatorRepo.findByUsername(s);
        Integer id;
        if(d!=null){
            id = d.getDNT_ID();
        }else{
            donatorRepo.saveAndFlush(Donator.builder().phoneNumber(s).username(s).build());
            Donator donator = donatorRepo.findByUsername(s);
            id = donator.getDNT_ID();
        }
        return id;
    }


    public void addProjectIdToFavoriteList(Integer projectId, Integer donatorid) {
        Donator donator = donatorRepo.findById(donatorid).orElseThrow();
        donator.setFavoriteProject(donator.getFavoriteProject() + projectId.toString() + " ");
        donatorRepo.saveAndFlush(donator);
    }

    public void removeProjectIdFromFavoriteList(Integer projectId, Integer donatorid) {
        Donator donator = donatorRepo.findById(donatorid).orElseThrow();
        String[] curFavoriteList = donator.getFavoriteProject().split(" "); // "1 2 10 11 " -> [1,2,10,11,]
        StringBuilder sb = new StringBuilder();
        for (String s : curFavoriteList) {
            if (!s.equals(projectId.toString())) sb.append(s).append(" ");
        }
        donator.setFavoriteProject(sb.toString());
        donatorRepo.saveAndFlush(donator);
    }

    public void changeStateFavoriteNotificationList(Integer donatorid,Integer notificationId,boolean value){
        if(value){
            addNotificationToFavoriteNotificationList(notificationId,donatorid);
        }else{
            removeNotificationFromFavoriteNotificationList(notificationId,donatorid);
        }
    }

    public void addNotificationToFavoriteNotificationList(Integer notificationId, Integer donatorid) {
        Donator donator = donatorRepo.findById(donatorid).orElseThrow();
        donator.setFavoriteNotification(donator.getFavoriteNotification() + notificationId.toString() + " ");
        donatorRepo.saveAndFlush(donator);
    }

    public void removeNotificationFromFavoriteNotificationList(Integer notificationId, Integer donatorid) {
        Donator donator = donatorRepo.findById(donatorid).orElseThrow();
        String[] curFavoriteList = donator.getFavoriteNotification().split(" ");
        StringBuilder sb = new StringBuilder();
        for (String s : curFavoriteList) {
            if (!s.equals(notificationId.toString())) sb.append(s).append(" ");
        }
        donator.setFavoriteNotification(sb.toString());
        donatorRepo.saveAndFlush(donator);
    }

    public int getTotalDonateMoneyOfDonatorByProjectId(Integer prjid,Integer dntid){
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(dntid, prjid);
        List<DonateDetails> donateDetails = donateDetailsService.findDonateDetailByDonateActivityId(donateActivity.getDNA_ID());
        int money=0;
        if(donateDetails.isEmpty()){
            return 0;
        }else{
            for(DonateDetails details: donateDetails){
                money+=details.getMoney();
            }
            return money;
        }
    }

    public void moveMoney(Integer project_id,Integer donator_id,Integer targetProjectId,Integer money) {
        DonateActivity oldDonateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, project_id);
        oldDonateActivity.setStatus(EDonateActivityStatus.FAILED.toString());
        donateActivityService.save(oldDonateActivity);
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, targetProjectId);
        if (donateActivity == null) {
            IDonateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivityService.save(DonateActivity.builder()
                            .donator(this.findById(donator_id))
                            .project(projectService.findProjectById(targetProjectId))
                            .status(EDonateActivityStatus.SUCCESSFUL.toString())
                            .build()))
                    .donateDate(LocalDateTime.now())
                    .money(money)
                    .build());
        }
        else {
            IDonateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivity)
                    .donateDate(LocalDateTime.now())
                    .money(money)
                    .build());
        }
    }

    public List<Boolean> getFavoriteNotificationOfDonator(Integer donator_id){
        List<PushNotification> lsp = IPushNotificationRepository.findAll();
        List<Boolean> result = new ArrayList<>();
        Donator d = donatorRepo.findById(donator_id).orElseThrow();
        for(PushNotification p:lsp){
            if(d.getFavoriteNotification().contains(p.getNOF_ID().toString())){
                result.add(true);
            }else{
                result.add(false);
            }
        }
        return result;
    }
}

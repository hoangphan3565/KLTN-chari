package com.macia.chariBE.service;

import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.model.DonateDetails;
import com.macia.chariBE.model.Donator;
import com.macia.chariBE.model.PushNotification;
import com.macia.chariBE.repository.DonateDetailsRepository;
import com.macia.chariBE.repository.DonatorRepository;
import com.macia.chariBE.repository.PushNotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class DonatorService {

    @Autowired
    private DonatorRepository donatorRepo;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private DonateDetailsRepository donateDetailsRepository;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private DonateDetailsService donateDetailsService;

    @Autowired
    private PushNotificationRepository pushNotificationRepository;

    public void save(Donator donator) {
        donatorRepo.saveAndFlush(donator);
    }

    public Donator findById(Integer id) {
        return donatorRepo.findById(id).orElseThrow();
    }

    public List<Donator> findAll(){return donatorRepo.findAll();}


    public Donator findByPhone(String phone) {
        try {
            return donatorRepo.findByPhoneNumber(phone);
        } catch (NoResultException e) {
            return null;
        }
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

    public void moveMoney(Integer donator_id,Integer targetProjectId,Integer money) {
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, targetProjectId);
        if (donateActivity == null) {
            donateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivityService.save(DonateActivity.builder()
                            .donator(this.findById(donator_id))
                            .project(projectService.findProjectById(targetProjectId))
                            .build()))
                    .donateDate(LocalDateTime.now())
                    .money(money)
                    .message("Chuyển tiền từ dự án cũ sang dự án khác")
                    .build());
        }
        else {
            donateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivity)
                    .donateDate(LocalDateTime.now())
                    .money(money)
                    .message("Chuyển tiền từ dự án cũ sang dự án khác")
                    .build());
        }
    }

    public List<Boolean> getFavoriteNotificationOfDonator(Integer donator_id){
        List<PushNotification> lsp = pushNotificationRepository.findAll();
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

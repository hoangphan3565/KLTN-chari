package com.macia.chariBE.service;

import com.macia.chariBE.DTO.DonateDetails.DonateDetailsOfDonatorDTO;
import com.macia.chariBE.DTO.DonateDetails.DonateDetailsOfProjectDTO;
import com.macia.chariBE.DTO.DonateDetails.DonateDetailsWithBankDTO;
import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.DonateDetailsRepository;
import com.macia.chariBE.repository.JwtUserRepository;
import com.macia.chariBE.utility.DonateActivityStatus;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DonateDetailsService {
    final static String donateCode = "CHARI";
    final static String disburseCode = "GIAINGAN";

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private DonateDetailsRepository donateDetailsRepository;

    @Autowired
    private DonatorService donatorService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private JwtUserRepository jwtUserRepository;

    @Autowired
    private DonatorNotificationService donatorNotificationService;

    public List<DonateDetailsOfDonatorDTO> findDonateDetailsByDonatorId(Integer donator_id) {
        try {
            TypedQuery<DonateDetailsOfDonatorDTO> query = em.createNamedQuery("named.donate_details.findByDonatorId", DonateDetailsOfDonatorDTO.class);
            query.setParameter("dntid", donator_id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<DonateDetailsOfProjectDTO> findDonateDetailsByProjectId(Integer id) {
        try {
            TypedQuery<DonateDetailsOfProjectDTO> query = em.createNamedQuery("named.donate_details.findByProjectId", DonateDetailsOfProjectDTO.class);
            query.setParameter("prjid", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<DonateDetails> findDonateDetailByDonateActivityId(Integer id) {
        try {
            TypedQuery<DonateDetails> query = em.createNamedQuery("named.donate_details.findByDonateActivityId", DonateDetails.class);
            query.setParameter("id", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    public List<DonateDetails> findByDonateActivityIdAndDateTime(Integer id,LocalDateTime datetime) {
        TypedQuery<DonateDetails> query = em.createNamedQuery("named.donate_details.findByDonateActivityIdAndDateTime", DonateDetails.class);
        query.setParameter("id", id);
        query.setParameter("datetime", datetime);
        return query.getResultList();
    }

    public String handleDonateDetails(String s){
        if(s.contains(donateCode)){
            return s.substring(s.indexOf(donateCode)).replace(donateCode,"").trim();
        }else if(s.contains(disburseCode)){
            return s.substring(s.indexOf(disburseCode)).replace(disburseCode,"").trim();
        }
        return "";
    }

    public Integer cutProjectIdFromDonateDetails(String s){
        String code = handleDonateDetails(s);
        return Integer.valueOf(code.split("_")[0]); //xoá hết ở sau _
    }

    public Integer findDonatorIdFromDonateDetails(String s){
        String details = cutPhoneFromDonateDetails(s);
        if(details.length()==10){
            return donatorService.getDonatorIdByPhone(details);
        }else{
            return donatorService.getDonatorIdByFacebookId(details);
        }
    }

    public String cutPhoneFromDonateDetails(String s){
        String code = handleDonateDetails(s);
        return code.substring(code.indexOf("_")+1).trim(); //xoá hết ở trước _
    }

    public Integer getDonateMoney(String s){
        String r = s.replace('+',' ').replace(",","").trim();
        return Integer.valueOf(r);
    }
    public void saveDonateDetailsWithBank(List<DonateDetailsWithBankDTO> donations) {
        List<DonateDetailsWithBankDTO> ds = donations.stream().filter(dn->dn.getDetails().toUpperCase().contains(donateCode)).collect(Collectors.toList());
        // s = "19/05/2021 08:06:17"
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        for(DonateDetailsWithBankDTO d:ds){
            Integer donator_id = findDonatorIdFromDonateDetails(d.getDetails().toUpperCase());
            Integer project_id = cutProjectIdFromDonateDetails(d.getDetails().toUpperCase());
            String phone = cutPhoneFromDonateDetails(d.getDetails().toUpperCase());
            Integer money = getDonateMoney(d.getAmount());
            saveDonateDetails(donator_id,project_id,money,LocalDateTime.parse(d.getDate(), formatter));

            System.out.println("Donator ID: "+donator_id);
            System.out.println("Project ID: "+project_id);
            System.out.println("Phone Or Facebook: "+phone);
            System.out.println("Money: "+money);
            System.out.println("======================");

        }
    }

    public void saveDonateDetails(Integer donator_id, Integer project_id, Integer money,LocalDateTime dateTime) {
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, project_id);
        if (donateActivity == null) {
            donateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivityService.save(DonateActivity.builder()
                            .donator(donatorService.findById(donator_id))
                            .project(projectService.findProjectById(project_id))
                            .status(DonateActivityStatus.SUCCESSFUL.toString())
                            .build()))
                    .donateDate(dateTime)
                    .money(money)
                    .build());
            sendDonateNotification(project_id);
        }
        else {
            //Để tránh lưu lại những lượt chuyển tiền đã được lưu
            if(this.findByDonateActivityIdAndDateTime(donateActivity.getDNA_ID(),dateTime).isEmpty()){
                donateDetailsRepository.save(DonateDetails.builder()
                        .donateActivity(donateActivity)
                        .donateDate(dateTime)
                        .money(money)
                        .build());
                sendDonateNotification(project_id);
            }
        }
    }

    public void sendDonateNotification(Integer project_id){
        String title = "Chari đã nhận được tiền quyên góp.";
        String message = "Cám ơn bạn đã đóng góp cho dự án: ";
        saveAndPushNotificationToDonator(project_id,message,title);
    }

    public void sendDisburedNotification(Integer project_id){
        String title = "Chari đã giải ngân tiền quyên góp.";
        String message = "Cám ơn bạn đã đóng góp cho dự án: ";
        saveAndPushNotificationToDonator(project_id,message,title);
    }

    private void saveAndPushNotificationToDonator(Integer project_id, String message, String title) {
        NotificationObject no = new NotificationObject();
        no.setTitle(title);
        List<DonateActivity> das = donateActivityService.findDonateActivityByProjectID(project_id);
        for(DonateActivity da:das){
            JwtUser appUser;
            if(da.getDonator().getPhoneNumber()!=null){
                appUser = jwtUserRepository.findByUsername(da.getDonator().getPhoneNumber());
            }else{
                appUser = jwtUserRepository.findByUsername(da.getDonator().getFacebookId());
            }
            no.setMessage(message+projectService.findProjectById(project_id).getProjectName());
            if(appUser!=null){
                if(da.getDonator().getDNT_ID()!=0){
                    if(appUser.getFcmToken() != null){
                        no.setToken(appUser.getFcmToken());
                        pushNotificationService.sendMessageToToken(no);
                    }
                    donatorNotificationService.save(DonatorNotification.builder()
                            .create_time(LocalDateTime.now()).donator(da.getDonator()).project_id(project_id)
                            .title(title).message(message+projectService.findProjectById(project_id).getProjectName())
                            .read(false).build());
                }
            }
        }
    }

    public void disbursedProjectWithBank(List<DonateDetailsWithBankDTO> donations) {
        List<DonateDetailsWithBankDTO> ds = donations.stream().filter(dn->dn.getDetails().toUpperCase().contains(disburseCode)).collect(Collectors.toList());
        for(DonateDetailsWithBankDTO d:ds){
            Integer project_id = Integer.valueOf(handleDonateDetails(d.getDetails()));
            Project p = projectService.findProjectById(project_id);
            if(!p.getDisbursed()){
                p.setDisbursed(true);
                projectService.save(p);
                sendDisburedNotification(project_id);
            }
        }
    }
}

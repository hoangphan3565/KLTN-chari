package com.macia.chariBE.service;

import com.macia.chariBE.DTO.DonateDetails.DonateDetailsOfDonatorDTO;
import com.macia.chariBE.DTO.DonateDetails.DonateDetailsOfProjectDTO;
import com.macia.chariBE.DTO.DonateDetails.DonateDetailsWithBankDTO;
import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.IDonateDetailsRepository;
import com.macia.chariBE.repository.IJwtUserRepository;
import com.macia.chariBE.repository.IPushNotificationRepository;
import com.macia.chariBE.utility.EDonateActivityStatus;
import com.macia.chariBE.utility.ENotificationTopic;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DonateDetailsService {
    final static String donateCode = "chari";
    final static String disburseCode = "giaingan";

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private IDonateDetailsRepository donateDetailsRepository;

    @Autowired
    private DonatorService donatorService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private IPushNotificationRepository pushNotificationRepository;

    @Autowired
    private IJwtUserRepository IJwtUserRepository;

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



    public int countAllDonateDetailsByDonatorIdAndProjectName(Integer id, String name) {
        try {
            TypedQuery<DonateDetailsOfDonatorDTO> query = em.createNamedQuery("named.donate_details.findByDonatorIdAndProjectName", DonateDetailsOfDonatorDTO.class);
            query.setParameter("dntid", id);
            query.setParameter("name", name);
            if(name.equals("*")){
                query.setParameter("name", "%"+""+"%");
            }else{
                query.setParameter("name", "%" + name.toLowerCase() + "%");
            }
            return query.getResultList().size();
        } catch (NoResultException e) {
            return -1;
        }
    }

    public List<DonateDetailsOfDonatorDTO> findDonateDetailsByDonatorIdAndProjectName(Integer id, String name, Integer a, Integer b) {
        try {
            TypedQuery<DonateDetailsOfDonatorDTO> query = em.createNamedQuery("named.donate_details.findByDonatorIdAndProjectName", DonateDetailsOfDonatorDTO.class)
                    .setFirstResult(a*b).setMaxResults(b);
            query.setParameter("dntid", id);
            query.setParameter("name", name);
            if(name.equals("*")){
                query.setParameter("name", "%"+""+"%");
            }else{
                query.setParameter("name", "%" + name.toLowerCase() + "%");
            }
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
        return Integer.valueOf(code.split("x")[0]); //xoá hết ở sau X
    }

    public Integer findDonatorIdFromDonateDetails(String s){
        String details = cutPhoneFromDonateDetails(s);
        return donatorService.getDonatorIdByUsername(details);
    }

    public String cutPhoneFromDonateDetails(String s){
        String code = handleDonateDetails(s);
        return code.substring(code.indexOf("x")+1).trim(); //xoá hết ở trước X
    }

    public Integer getDonateMoney(String s){
        String r = s.replace('+',' ').replace(",","").trim();
        return Integer.valueOf(r);
    }

    public Integer getDisburseMoney(String s){
        String r = s.replace('-',' ').replace(",","").trim();
        return Integer.valueOf(r);
    }
    public void saveDonateDetailsWithBank(List<DonateDetailsWithBankDTO> donations) {
        List<DonateDetailsWithBankDTO> ds = donations.stream()
                .filter(dn->dn.getDetails()!=null)
                .filter(dn->dn.getDetails().toLowerCase().contains(donateCode))
                .collect(Collectors.toList());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        for(DonateDetailsWithBankDTO d:ds){
            Integer donator_id = findDonatorIdFromDonateDetails(d.getDetails().toLowerCase());
            Integer project_id = cutProjectIdFromDonateDetails(d.getDetails().toLowerCase());
            Integer money = getDonateMoney(d.getAmount());
            System.out.println("========================");
            System.out.println("Donator: "+donator_id);
            System.out.println("ProjectId: "+project_id);
            System.out.println("Money: "+money);
            saveDonateDetails(donator_id,project_id,money,LocalDateTime.parse(d.getDate(), formatter));
        }
        projectService.updateAllProjectStatus();
    }

    public void saveDonateDetails(Integer donator_id, Integer project_id, Integer money,LocalDateTime dateTime) {
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, project_id);
        if (donateActivity == null) {
            donateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivityService.save(DonateActivity.builder()
                            .donator(donatorService.findById(donator_id))
                            .project(projectService.findProjectById(project_id))
                            .status(EDonateActivityStatus.SUCCESSFUL.toString())
                            .build()))
                    .donateDate(dateTime)
                    .money(money)
                    .build());
            sendDonateNotificationToDonator(donator_id,project_id);
        }
        else {
            if(this.findByDonateActivityIdAndDateTime(donateActivity.getDNA_ID(),dateTime).isEmpty()){
                donateDetailsRepository.save(DonateDetails.builder()
                        .donateActivity(donateActivity)
                        .donateDate(dateTime)
                        .money(money)
                        .build());
                sendDonateNotificationToDonator(donator_id,project_id);
            }
        }
    }

    public void sendDonateNotificationToDonator(Integer donator_id,Integer project_id){
        PushNotification pn = pushNotificationRepository.findByTopic(ENotificationTopic.DONATED);
        Project project = projectService.findProjectById(project_id);
        String msg = "Dự án '"+project.getProjectName()+"'"+pn.getMessage();
        NotificationObject no = new NotificationObject();
        no.setTitle(pn.getTitle());
        no.setTopic(pn.getTopic());
        JwtUser appUser;
        DonateActivity da = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id,project_id);
        appUser = IJwtUserRepository.findByUsername(da.getDonator().getUsername());
        no.setMessage(msg);
        Donator donator = da.getDonator();
        if(donator.getDNT_ID()!=0 && donator.getFavoriteNotification()!=null){
            String notifications = donator.getFavoriteNotification();
            if(notifications.contains(pn.getNOF_ID().toString())){
                if(appUser!=null){
                    if(da.getDonator().getDNT_ID()!=0){
                        if(appUser.getFcmToken() != null){
                            no.setToken(appUser.getFcmToken());
                            pushNotificationService.sendMessageToToken(no);
                        }
                        donatorNotificationService.save(DonatorNotification.builder()
                                .topic(pn.getTopic()).title(pn.getTitle()).message(msg)
                                .create_time(LocalDateTime.now()).read(false).handled(false)
                                .donator(da.getDonator()).project_id(project_id).project_image(project.getImageUrl()).build());
                    }
                }
            }
        }
    }

    public int disbursedProjectWithBank(List<DonateDetailsWithBankDTO> donations) {
        int flag=0;
        List<DonateDetailsWithBankDTO> ds = donations.stream()
                .filter(dn->dn.getDetails()!=null)
                .filter(dn->dn.getDetails().toLowerCase().contains(disburseCode))
                .collect(Collectors.toList());
        PushNotification pn = pushNotificationRepository.findByTopic(ENotificationTopic.DISBURSED);
        for(DonateDetailsWithBankDTO d:ds){
            Integer project_id = Integer.valueOf(handleDonateDetails(d.getDetails().toLowerCase()));
            System.out.println("========================");
            System.out.println("ProjectId: "+project_id);
            Project p = projectService.findProjectById(project_id);
            if(!p.getDisbursed()){
                if(getDisburseMoney(d.getAmount())>=projectService.findCurMoneyOfProject(p)){
                    p.setDisbursed(true);
                    projectService.save(p);
                    donatorNotificationService.saveAndPushNotificationToUser(pn,project_id);
                }else{
                    flag=1;
                }
            }
        }
        projectService.updateAllProjectStatus();
        return flag;
    }
}

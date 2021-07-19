package com.macia.chariBE.service;

import com.macia.chariBE.DTO.SupportedPeopleDraftDTO;
import com.macia.chariBE.model.*;
import com.macia.chariBE.repository.*;
import com.macia.chariBE.utility.ENotificationTopic;
import com.macia.chariBE.utility.EProcessingStatus;
import com.macia.chariBE.utility.EProjectStatus;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Service
public class SupportedPeopleRecommendService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ISupportedPeopleRecommendRepository repo;

    @Autowired
    private DonatorService donatorService;

    @Autowired
    private IPushNotificationRepository pushNotificationRepository;

    @Autowired
    private ISupportedPeopleDraftRepository draftRepository;

    @Autowired
    private CollaboratorService collaboratorService;

    @Autowired
    private SupportedPeopleDraftService supportedPeopleDraftService;

    @Autowired
    private ProjectImagesService projectImagesService;

    @Autowired
    private ISupportedPeopleRepository supportedPeopleRepository;

    @Autowired
    private IProjectRepository projectRepository;

    @Autowired
    private ProjectTypeService projectTypeService;

    @Autowired
    private ICityRepository cityRepository;

    @Autowired
    private DonatorNotificationService donatorNotificationService;

    public void save(SupportedPeopleRecommend s) {
        repo.saveAndFlush(s);
    }

    public int countAll() {
        try {
            TypedQuery<SupportedPeopleRecommend> query = em.createNamedQuery("named.supportedPeopleRecommend.findAll", SupportedPeopleRecommend.class);
            return query.getResultList().size();
        } catch (NoResultException e) {
            return -1;
        }
    }

    public List<SupportedPeopleRecommend> findPageASizeB(int a, int b) {
        try {
            TypedQuery<SupportedPeopleRecommend> query = em.createNamedQuery("named.supportedPeopleRecommend.findAll", SupportedPeopleRecommend.class)
                    .setFirstResult(a*b).setMaxResults(b);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    public JSONObject checkStatus(Integer id,Integer clb_id) {
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            SupportedPeopleRecommend s = repo.findById(id).orElseThrow();
            if(s.getStatus().equals(EProcessingStatus.PENDING)){
                jso.put("errorCode",0);
                jso.put("message","Hoàn cảnh chưa được xử lý!");
                handle(id,clb_id);
                jso.put("data",supportedPeopleDraftService.getDraftDTOById(id));
            }else if(s.getStatus().equals(EProcessingStatus.PROCESSING)){
               if(s.getCollaborator().getCLB_ID().equals(clb_id)){
                   jso.put("errorCode",0);
                   jso.put("data",supportedPeopleDraftService.getDraftDTOById(id));
                   jso.put("message","Tiếp tục xử lý!");
               }else{
                   jso.put("errorCode",1);
                   jso.put("message","Dự án đang được xử lý bởi một cộng tác viên khác!");
               }
            }else{
                jso.put("errorCode",1);
                jso.put("message","Hoàn cảnh đã được xử lý!");
            }
        }else{
            jso.put("errorCode",1);
            jso.put("message","Hoàn cảnh đã bị xoá trước đó!");
        }
        return jso;
    }


    public void handle(Integer id,Integer clb_id) {
        SupportedPeopleRecommend s = repo.findById(id).orElseThrow();
        s.setStatus(EProcessingStatus.PROCESSING);
        s.setCollaborator(collaboratorService.findById(clb_id));
        if(draftRepository.findBySprID(s.getSPR_ID())==null){
            draftRepository.saveAndFlush(SupportedPeopleDraft.builder()
                    .referrerName(s.getReferrerName())
                    .referrerPhone(s.getReferrerPhone())
                    .referrerDescription(s.getReferrerDescription())
                    .fullName(s.getFullName()).address(s.getAddress()).phoneNumber(s.getPhoneNumber())
                    .bankName(s.getBankName()).bankAccount(s.getBankAccount()).sprID(s.getSPR_ID())
                    .projectName(null).projectType(null).briefDescription(null).description(null)
                    .city(null).imageUrl(null).videoUrl(null).draftImages(null).startDate(null).endDate(null).targetMoney(null)
                    .collaborator(s.getCollaborator()).build());
        }
        repo.saveAndFlush(s);
    }


    public void unHandle(Integer id) {
        SupportedPeopleRecommend s = repo.findById(id).orElseThrow();
        s.setStatus(EProcessingStatus.PENDING);
        s.setCollaborator(null);
        draftRepository.delete(draftRepository.findBySprID(s.getSPR_ID()));
        repo.saveAndFlush(s);
    }

    public JSONObject saveDraftStep1(SupportedPeopleDraftDTO sp) {
        JSONObject jso = new JSONObject();
        supportedPeopleDraftService.updateDraftStep1(sp);
        jso.put("errorCode",0);
        jso.put("message","Cập nhật bản nháp thành công!");
        return jso;
    }

    public JSONObject saveDraftStep2(SupportedPeopleDraftDTO sp) {
        JSONObject jso = new JSONObject();
        supportedPeopleDraftService.updateDraftStep2(sp);
        jso.put("errorCode",0);
        jso.put("message","Cập nhật bản nháp thành công!");
        return jso;
    }

    public JSONObject createProject(SupportedPeopleDraftDTO p) {
        JSONObject jso = new JSONObject();
        SupportedPeople s = new SupportedPeople();
        s.setFullName(p.getFullName());
        s.setAddress(p.getAddress());
        s.setPhoneNumber(p.getPhoneNumber());
        s.setBankName(p.getBankName());
        s.setBankAccount(p.getBankAccount());
        s.setCollaborator(this.collaboratorService.findById(p.getClb_ID()));
        supportedPeopleRepository.saveAndFlush(s);

        Project np = new Project();
        np.setProjectName(p.getProjectName());
        np.setBriefDescription(p.getBriefDescription());
        np.setDescription(p.getDescription());
        np.setStartDate(p.getStartDate());
        np.setEndDate(p.getEndDate());
        np.setTargetMoney(p.getTargetMoney());
        np.setImageUrl(p.getImageUrl());
        np.setVideoUrl(p.getVideoUrl());
        np.setSupportedPeople(s);
        np.setProjectType(this.projectTypeService.findById(p.getPrt_ID()));
        np.setCity(this.cityRepository.findById(p.getCti_ID()).orElseThrow());
        np.setCollaborator(this.collaboratorService.findById(p.getClb_ID()));
        np.setProjectImages(projectImagesService.createListProjectImage(np,p.getImages()));
        np.setVerified(p.getClb_ID()==0);
        np.setDisbursed(false);
        np.setClosed(false);
        np.setStatus(EProjectStatus.ACTIVATING);
        projectRepository.saveAndFlush(np);

        Donator donator = donatorService.findByUsername(p.getReferrerPhone());
        if(donator!=null){
            PushNotification pn = pushNotificationRepository.findByTopic(ENotificationTopic.INTRODUCTION);
            donatorNotificationService.saveAndPushNotificationToOneUser(donator,pn,np);
        }
        if(p.getClb_ID() == 0){
            this.donatorNotificationService.saveAndPushNotificationToAllUser(np, ENotificationTopic.NEW);
        }

        repo.deleteById(p.getSprID());

        jso.put("errorCode",0);
        jso.put("message","Tạo dự án thành công!");
        return jso;
    }
}

package com.macia.chariBE.service;

import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.DTO.SupportedPeopleDraftDTO;
import com.macia.chariBE.model.City;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.model.SupportedPeopleDraft;
import com.macia.chariBE.repository.ICityRepository;
import com.macia.chariBE.repository.ISupportedPeopleDraftRepository;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.time.LocalDate;

@Service
public class SupportedPeopleDraftService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ISupportedPeopleDraftRepository repo;

    @Autowired
    private SupportedPeopleDraftImagesService imagesService;

    @Autowired
    private ProjectTypeService projectTypeService;

    @Autowired
    private ICityRepository cityRepository;


    public JSONObject updateDraftStep1(SupportedPeopleDraftDTO p) {
        JSONObject jso = new JSONObject();
        SupportedPeopleDraft np = repo.findById(p.getSPD_ID()).orElseThrow();
        if(np!=null){
            np.setFullName(p.getFullName());
            np.setAddress(p.getAddress());
            np.setPhoneNumber(p.getPhoneNumber());
            np.setBankName(p.getBankName());
            np.setBankAccount(p.getBankAccount());
            this.repo.saveAndFlush(np);
            jso.put("errorCode", 0);
            jso.put("message", "Cập nhật bảng nháp thành công!");
        }else{
            jso.put("errorCode", 1);
            jso.put("message", "Cập nhật thất bại, hoàn cảnh đã bị xoá trước đó!");
        }
        return jso;
    }

    public JSONObject updateDraftStep2(SupportedPeopleDraftDTO p) {
        JSONObject jso = new JSONObject();
        SupportedPeopleDraft np = repo.findById(p.getSPD_ID()).orElseThrow();
        LocalDate startDate=null,endDate=null;
        ProjectType projectType=null;
        City city=null;
        if(p.getStartDate()!=null){
            startDate = LocalDate.parse(p.getStartDate().toString().split("T")[0]);
        }
        if(p.getEndDate()!=null){
            endDate = LocalDate.parse(p.getStartDate().toString().split("T")[0]);
        }
        if(p.getPrt_ID()!=null){
            projectType=this.projectTypeService.findById(p.getPrt_ID());
        }
        if(p.getCti_ID()!=null){
            city=this.cityRepository.findById(p.getCti_ID()).orElseThrow();
        }
        if(np!=null){
            np.setProjectName(p.getProjectName());
            np.setBriefDescription(p.getBriefDescription());
            np.setDescription(p.getDescription());
            np.setStartDate(startDate);
            np.setEndDate(endDate);
            np.setTargetMoney(p.getTargetMoney());
            np.setImageUrl(p.getImageUrl());
            np.setVideoUrl(p.getVideoUrl());
            np.setProjectType(projectType);
            np.setCity(city);
            this.imagesService.updateList(np,p.getImages());
            this.repo.saveAndFlush(np);
            jso.put("errorCode", 0);
            jso.put("message", "Cập nhật bảng nháp thành công!");
        }else{
            jso.put("errorCode", 1);
            jso.put("message", "Cập nhật thất bại, hoàn cảnh đã bị xoá trước đó!");
        }
        return jso;
    }



    public SupportedPeopleDraftDTO getDraftDTOById(Integer spr_id){
        return this.mapToDTO(repo.findBySprID(spr_id));
    }

    private SupportedPeopleDraftDTO mapToDTO(SupportedPeopleDraft p){
        Integer prt_id=null,cti_id=null;
        Boolean canDisburseWhenOverdue=true;
        if(p.getProjectType()!=null){
            prt_id=p.getProjectType().getPRT_ID();
            canDisburseWhenOverdue=p.getProjectType().getCanDisburseWhenOverdue();
        }
        if(p.getCity()!=null){
            cti_id=p.getCity().getCTI_ID();
        }
        return SupportedPeopleDraftDTO.builder()
                .SPD_ID(p.getSPD_ID()).sprID(p.getSprID())
                .referrerName(p.getReferrerName()).referrerPhone(p.getReferrerPhone()).referrerDescription(p.getReferrerDescription())
                .fullName(p.getFullName()).address(p.getAddress()).phoneNumber(p.getPhoneNumber())
                .bankAccount(p.getBankAccount()).bankName(p.getBankName())
                .projectName(p.getProjectName()).briefDescription(p.getBriefDescription()).description(p.getDescription())
                .imageUrl(p.getImageUrl()).videoUrl(p.getVideoUrl()).canDisburseWhenOverdue(canDisburseWhenOverdue)
                .images(this.imagesService.findListStringImage(p.getSPD_ID())).targetMoney(p.getTargetMoney())
                .startDate(p.getStartDate()).endDate(p.getEndDate())
                .prt_ID(prt_id).projectType(p.getProjectType())
                .cti_ID(cti_id).city(p.getCity())
                .build();
    }
}

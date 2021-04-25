package com.macia.chariBE.service;

import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.model.DonateDetails;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.repository.ProjectRepository;
import com.macia.chariBE.utility.ProjectStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.persistence.*;
import java.time.Duration;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ProjectService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ProjectRepository repo;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private DonateDetailsService donateDetailsService;

    public Project save(Project project) {
        return repo.saveAndFlush(project);
    }

    public Project findProjectById(Integer id) {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findById", Project.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public int findCurMoneyOfProject(Project p){
        int curMoney = 0;
        List<DonateActivity> donateActivityList = donateActivityService.findDonateActivityByProjectID(p.getPRJ_ID());
        if(!donateActivityList.isEmpty()){
            for(DonateActivity donateActivity:donateActivityList){
                List<DonateDetails> donateDetailsList = donateDetailsService.findDonateDetailByDonateActivityId(donateActivity.getDNA_ID());
                for(DonateDetails donateDetails: donateDetailsList){
                    curMoney+=donateDetails.getMoney();
                }
            }
        }
        return curMoney;
    }

    public Integer findNumOfDonationOfProject(Project p){
        Integer numOfDonate = 0;
        List<DonateActivity> donateActivityList = donateActivityService.findDonateActivityByProjectID(p.getPRJ_ID());
        if(!donateActivityList.isEmpty()){
            for(DonateActivity donateActivity:donateActivityList){
                List<DonateDetails> donateDetailsList = donateDetailsService.findDonateDetailByDonateActivityId(donateActivity.getDNA_ID());
                for(DonateDetails donateDetails: donateDetailsList){
                    numOfDonate++;
                }
            }
        }
        return numOfDonate;
    }

    public long findRemainingTermOfProject(Project p){
        return ChronoUnit.DAYS.between(LocalDate.now(), p.getEndDate());
    }

    public String findStatusOfProject(Project p){
        int curMoney = this.findCurMoneyOfProject(p);
        long remainingTerm = this.findRemainingTermOfProject(p);
        if(curMoney>=p.getTargetMoney()){
            return ProjectStatus.REACHED.toString();
        }else{
            if(remainingTerm<=0){
                return ProjectStatus.OVERDUE.toString();
            }
        }
        return ProjectStatus.ACTIVATING.toString();
    }

    public List<Project> getAllProjects(){
        return repo.findAll();
    }

    public List<Project> getUnverifiedProjects(){
        return repo.findAll().stream().filter(p-> !p.getVerified()).collect(Collectors.toList());
    }

    public List<Project> approveProject(Integer id){
        Project p = repo.findById(id).orElseThrow();
        p.setVerified(true);
        repo.saveAndFlush(p);
        return this.getUnverifiedProjects();
    }

    public List<ProjectDTO> getProjectDTOs(){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = repo.findAll().stream().filter(Project::getVerified).collect(Collectors.toList());
        for(Project p : ps){
            r.add(ProjectDTO.builder()
                    .prj_id(p.getPRJ_ID())
                    .project_code(p.getProjectCode())
                    .project_name(p.getProjectName())
                    .brief_description(p.getBriefDescription())
                    .description(p.getDescription())
                    .image_url(p.getImageUrl())
                    .video_url(p.getVideoUrl())
                    .target_money(p.getTargetMoney())
                    .cur_money(Integer.valueOf(String.valueOf(findCurMoneyOfProject(p))))
                    .num_of_donations(this.findNumOfDonationOfProject(p))
                    .remaining_term(Integer.valueOf(String.valueOf(this.findRemainingTermOfProject(p))))
                    .prt_id(p.getProjectType().getPRT_ID())
                    .project_type_name(p.getProjectType().getProjectTypeName())
                    .status(this.findStatusOfProject(p))
                    .build());
        }
        return r;
    }

    public List<ProjectDTO> getActivatingProjectDTOs(){
        return this.getProjectDTOs().stream().
                filter(p->p.getStatus().equals(ProjectStatus.ACTIVATING.toString()))
                .collect(Collectors.toList());
    }
    public List<ProjectDTO> getReachedProjectDTOs(){
        return this.getProjectDTOs().stream().
                filter(p->p.getStatus().equals(ProjectStatus.REACHED.toString()))
                .collect(Collectors.toList());
    }
    public List<ProjectDTO> getOverdueProjectDTOs(){
        return this.getProjectDTOs().stream().
                filter(p->p.getStatus().equals(ProjectStatus.OVERDUE.toString()))
                .collect(Collectors.toList());
    }
}

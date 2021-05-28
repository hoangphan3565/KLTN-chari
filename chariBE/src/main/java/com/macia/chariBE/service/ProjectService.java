package com.macia.chariBE.service;

//import com.macia.chariBE.DTO.Project.ProjectDTOForAdmin;
import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.model.DonateDetails;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.repository.ProjectRepository;
import com.macia.chariBE.utility.ProjectStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
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

    @Autowired
    private DonatorNotificationService donatorNotificationService;

    @Autowired
    private ProjectImagesService projectImagesService;

    @Autowired
    private ProjectTypeService projectTypeService;

    @Autowired
    private SupportedPeopleService supportedPeopleService;

    @Autowired
    private CollaboratorService collaboratorService;

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
    public Project findProjectByCharityProgramId(Integer id) {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findByProjectTypeId", Project.class);
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

    public List<ProjectDTO> getUnverifiedProjects(){
        return getProjectDTOs().stream().filter(p-> !p.getVerified()).collect(Collectors.toList());
    }
    public List<ProjectDTO> getVerifiedProjects(){
        return getProjectDTOs().stream().filter(ProjectDTO::getVerified).filter(p->!p.getClosed()).collect(Collectors.toList());
    }

    public List<Project> getClosedProjects(){
        return repo.findAll().stream().filter(Project::getClosed).collect(Collectors.toList());
    }

    public List<ProjectDTO> approveProject(Integer id){
        Project p = repo.findById(id).orElseThrow();
        p.setVerified(true);
        repo.saveAndFlush(p);
        return this.getUnverifiedProjects();
    }

    public List<ProjectDTO> closeProject(Integer id){
        Project p = repo.findById(id).orElseThrow();
        p.setClosed(true);
        repo.saveAndFlush(p);
        return this.getOverdueProjectDTOs();
    }

    public List<ProjectDTO> extendProject(Integer id,Integer nod){
        Project p = repo.findById(id).orElseThrow();
        p.setEndDate(LocalDate.now().plusDays(nod));
        repo.saveAndFlush(p);
        return this.getOverdueProjectDTOs();
    }

    private float findPriorityPoint(Project p){
        float point=1000;
        String curMoney = String.valueOf(findCurMoneyOfProject(p));
        if(findStatusOfProject(p).equals((ProjectStatus.ACTIVATING).toString())){
            if(curMoney.equals("0")){
                point=999;
            }else{
                point-=(Float.parseFloat(curMoney) /Float.parseFloat(p.getTargetMoney().toString()))*Integer.parseInt(String.valueOf(findRemainingTermOfProject(p)));
            }
        }
        if(findStatusOfProject(p).equals((ProjectStatus.REACHED).toString())){
            point=300;
        }
        if(findStatusOfProject(p).equals((ProjectStatus.OVERDUE).toString())){
            point=0;
        }
        return  point;
    }
    public List<ProjectDTO> getProjectDTOs(){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = repo.findAll();
        for(Project p : ps){
            r.add(ProjectDTO.builder()
                    .PRJ_ID(p.getPRJ_ID()).projectCode(p.getProjectCode()).projectName(p.getProjectName())
                    .briefDescription(p.getBriefDescription()).description(p.getDescription())
                    .imageUrl(p.getImageUrl()).videoUrl(p.getVideoUrl())
                    .images(this.projectImagesService.findProjectImagesByProjectId(p.getPRJ_ID()))
                    .targetMoney(p.getTargetMoney()).curMoney(Integer.valueOf(String.valueOf(findCurMoneyOfProject(p))))
                    .numOfDonations(findNumOfDonationOfProject(p))
                    .startDate(p.getStartDate().toString()).endDate(p.getEndDate().toString())
                    .remainingTerm(Integer.valueOf(String.valueOf(findRemainingTermOfProject(p))))
                    .verified(p.getVerified()).status(findStatusOfProject(p)).disbursed(p.getDisbursed()).closed(p.getClosed())
                    .prt_ID(p.getProjectType().getPRT_ID()).projectType(p.getProjectType())
                    .stp_ID(p.getSupportedPeople().getSTP_ID()).supportedPeople(p.getSupportedPeople())
                    .clb_ID(p.getCollaborator().getCLB_ID()).collaborator(p.getCollaborator())
                    .priorityPoint(findPriorityPoint(p))
                    .build());
        }
        return r;
    }

    public List<ProjectDTO> getProjectReadyToMoveMoney(int money){
        return this.getActivatingProjectDTOs().stream()
                .filter(p->p.getTargetMoney()-p.getCurMoney()>=money)
                .collect(Collectors.toList());
    }

    public List<ProjectDTO> getActivatingProjectDTOs(){
        return this.getProjectDTOs().stream()
                .filter(p-> !p.getClosed())
                .filter(p->p.getStatus().equals(ProjectStatus.ACTIVATING.toString()))
                .collect(Collectors.toList());
    }

    public List<ProjectDTO> getReachedProjectDTOs(){
        return this.getProjectDTOs().stream().
                filter(p-> !p.getClosed()).
                filter(p->p.getStatus().equals(ProjectStatus.REACHED.toString()))
                .collect(Collectors.toList());
    }

    public List<ProjectDTO> getOverdueProjectDTOs(){
        return this.getProjectDTOs().stream().
                filter(p-> !p.getClosed()).
                filter(p->p.getStatus().equals(ProjectStatus.OVERDUE.toString()))
                .collect(Collectors.toList());
    }

    public List<Project> createProject(ProjectDTO p,Boolean isAdmin){
        Project np = new Project();
        np.setProjectName(p.getProjectName());
        np.setBriefDescription(p.getBriefDescription());
        np.setDescription(p.getDescription());
        np.setStartDate(LocalDate.parse(p.getStartDate().split("T")[0]));
        np.setEndDate(LocalDate.parse(p.getEndDate().split("T")[0]));
        np.setTargetMoney(p.getTargetMoney());
        np.setImageUrl(p.getImageUrl());
        np.setVideoUrl(p.getVideoUrl());
        np.setProjectType(this.projectTypeService.findById(p.getPrt_ID()));
        np.setSupportedPeople(this.supportedPeopleService.findById(p.getStp_ID()));
        np.setCollaborator(this.collaboratorService.findById(0));
        np.setVerified(isAdmin);
        np.setDisbursed(false);
        np.setClosed(false);
        this.repo.saveAndFlush(np);
        this.projectImagesService.saveProjectImageToProjectWithListImage(np,p.getImages());
        this.donatorNotificationService.saveAndPushNotificationToAllUser(np.getPRJ_ID(),"new");
        return this.getAllProjects();
    }

    public List<Project> updateProject(ProjectDTO p) {
        Project np = this.findProjectById(p.getPRJ_ID());
        np.setProjectName(p.getProjectName());
        np.setBriefDescription(p.getBriefDescription());
        np.setDescription(p.getDescription());
        np.setStartDate(LocalDate.parse(p.getStartDate().split("T")[0]));
        np.setEndDate(LocalDate.parse(p.getEndDate().split("T")[0]));
        np.setTargetMoney(p.getTargetMoney());
        np.setImageUrl(p.getImageUrl());
        np.setVideoUrl(p.getVideoUrl());
        np.setProjectType(this.projectTypeService.findById(p.getPrt_ID()));
        np.setSupportedPeople(this.supportedPeopleService.findById(p.getStp_ID()));
        this.repo.saveAndFlush(np);
        return this.getAllProjects();
    }
}

package com.macia.chariBE.service;

//import com.macia.chariBE.DTO.Project.ProjectDTOForAdmin;
import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.model.DonateDetails;
import com.macia.chariBE.model.Donator;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.repository.CityRepository;
import com.macia.chariBE.repository.ProjectRepository;
import com.macia.chariBE.utility.ProjectStatus;
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
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import static com.macia.chariBE.utility.Round.round;


@Service
public class ProjectService {



    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ProjectRepository repo;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private DonatorService donatorService;

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
    private CityRepository cityRepository;

    @Autowired
    private CollaboratorService collaboratorService;

    public Project save(Project project) {
        return repo.saveAndFlush(project);
    }

    public List<Project> findFavoriteProject(Integer donatorId) {
        try {
            Donator donator = donatorService.findById(donatorId);
            String[] curFavoriteList = donator.getFavoriteProject().split(" ");
            List<Integer> id = new ArrayList<>();
            for (String s : curFavoriteList) {
                id.add(Integer.valueOf(s));
            }
            TypedQuery<Project> query = em.createNamedQuery("named.project.findFavoriteProject", Project.class);
            query.setParameter("ids", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    public List<ProjectDTO> getFavoriteProjectDTOsByDonatorId(Integer id){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = this.findFavoriteProject(id);
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
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

    public List<Project> findAll() {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findAll", Project.class);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    // Services for Collaborator(Only show Unclose Project Of them)
    public Integer countAllByCollaboratorId(Integer id) {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUncloseByCollaboratorId", Project.class);
        query.setParameter("id", id);
        return query.getResultList().size();
    }
    // pagination
    public List<Project> findUncloseProjectByCollaboratorIdFromAToB(Integer id,Integer a,Integer b) {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findUncloseByCollaboratorId", Project.class)
                    .setFirstResult(a)
                    .setMaxResults(b-a);
            query.setParameter("id", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    public List<ProjectDTO> getUncloseProjectDTOsByCollaboratorIdFromAToB(Integer id,Integer a,Integer b){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = this.findUncloseProjectByCollaboratorIdFromAToB(id,a,b);
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }



    // Services for Donator(Only show Verified and Unclose) and Admin(Verified Project)

    public Integer countAllWhereUncloseAndVerified() {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findWhereUncloseAndVerified", Project.class);
        return query.getResultList().size();
    }
    public List<Project> findUncloseAndVerifiedProjectsFromAToB(Integer a,Integer b) {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findWhereUncloseAndVerified", Project.class)
                    .setFirstResult(a)
                    .setMaxResults(b-a);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    public List<ProjectDTO> getProjectDTOsWhereUncloseAndVerifiedFromAToB(Integer a,Integer b){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = this.findUncloseAndVerifiedProjectsFromAToB(a,b);
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }

    public List<Project> findUncloseAndVerifiedByName(String name) {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findUncloseAndVerifiedByName", Project.class);
            query.setParameter("name", "%" + name.toLowerCase() + "%");
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<ProjectDTO> getProjectDTOsUncloseAndVerifiedByName(String name){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = this.findUncloseAndVerifiedByName(name);
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }


    public String getImageUrlOfProjectById(Integer id){
        return findProjectById(id).getImageUrl();
    }

    public Project findProjectByProjectTypeId(Integer id) {
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

    public int findCurMoneyOfProjectById(Integer id){
        int curMoney = 0;
        List<DonateActivity> donateActivityList = donateActivityService.findDonateActivityByProjectID(id);
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

    private double findAchieved(Project p){
        return round(findCurMoneyOfProject(p)/p.getTargetMoney().doubleValue()*100,1);
    }

    public List<ProjectDTO> getUnverifiedProjects(){
        return getProjectDTOs().stream()
                .filter(p-> !p.getVerified())
                .collect(Collectors.toList());
    }
    public List<ProjectDTO> getVerifiedProjects(){
        return getProjectDTOs().stream()
                .filter(ProjectDTO::getVerified)
                .filter(p->!p.getClosed())
                .collect(Collectors.toList());
    }

    public int findMovedMoneyOfClosedProject(Integer prjid){
        int money=0;
        List<DonateActivity> donateActivities = donateActivityService.findByProjectIdAndClosedNonDisburse(prjid);
        for(DonateActivity da:donateActivities){
            List<DonateDetails> donateDetails = donateDetailsService.findDonateDetailByDonateActivityId(da.getDNA_ID());
            for(DonateDetails details: donateDetails){
                money+=details.getMoney();
            }
        }
        return money;
    }


    public List<ProjectDTO> approveProject(Integer id){
        Project p = repo.findById(id).orElseThrow();
        p.setVerified(true);
        repo.saveAndFlush(p);
        return this.getUnverifiedProjects();
    }

    public List<ProjectDTO> closeProject(Integer id,Integer clb_id){
        Project p = repo.findById(id).orElseThrow();
        p.setClosed(true);
        p.setUpdateTime(LocalDateTime.now().minusYears(10));
        repo.saveAndFlush(p);
        if(clb_id==0){
            return this.getOverdueProjectDTOs();
        }else{
            return this.getOverdueProjectDTOs().stream()
                    .filter(x-> x.getCollaborator().getCLB_ID().equals(clb_id))
                    .collect(Collectors.toList());
        }
    }

    public List<ProjectDTO> extendProject(Integer id,Integer nod,Integer clb_id){
        Project p = repo.findById(id).orElseThrow();
        p.setEndDate(LocalDate.now().plusDays(nod));
        repo.saveAndFlush(p);
        if(clb_id==0){
            return this.getOverdueProjectDTOs();
        }else{
            return this.getOverdueProjectDTOs().stream()
                    .filter(x-> x.getCollaborator().getCLB_ID().equals(clb_id))
                    .collect(Collectors.toList());
        }
    }

    private ProjectDTO mapToDTO(Project p){
        return ProjectDTO.builder()
                .PRJ_ID(p.getPRJ_ID()).projectCode(p.getProjectCode()).projectName(p.getProjectName())
                .briefDescription(p.getBriefDescription()).description(p.getDescription())
                .imageUrl(p.getImageUrl()).videoUrl(p.getVideoUrl())
                .images(this.projectImagesService.findListStringProjectImagesByProjectId(p.getPRJ_ID()))
                .targetMoney(p.getTargetMoney()).curMoney(Integer.valueOf(String.valueOf(findCurMoneyOfProject(p))))
                .achieved(findAchieved(p))
                .numOfDonations(findNumOfDonationOfProject(p))
                .startDate(p.getStartDate().toString()).endDate(p.getEndDate().toString())
                .remainingTerm(Integer.valueOf(String.valueOf(findRemainingTermOfProject(p))))
                .verified(p.getVerified()).status(findStatusOfProject(p)).disbursed(p.getDisbursed()).closed(p.getClosed())
                .prt_ID(p.getProjectType().getPRT_ID()).projectType(p.getProjectType())
                .stp_ID(p.getSupportedPeople().getSTP_ID()).supportedPeople(p.getSupportedPeople())
                .clb_ID(p.getCollaborator().getCLB_ID()).collaborator(p.getCollaborator())
                .cti_ID(p.getCity().getCTI_ID()).city(p.getCity())
                .build();
    }

    public List<ProjectDTO> getProjectDTOById(Integer id){
        List<ProjectDTO> r = new ArrayList<>();
        Project p = this.findProjectById(id);
        r.add(mapToDTO(p));
        return r;
    }



    public List<ProjectDTO> getProjectDTOs(){
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = this.findAll();
        for(Project p : ps){
            r.add(mapToDTO(p));
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
        return this.getProjectDTOs().stream()
                .filter(p-> !p.getClosed())
                .filter(p->p.getStatus().equals(ProjectStatus.OVERDUE.toString()))
                .sorted(Comparator.comparing(ProjectDTO::getCurMoney).reversed())
                .collect(Collectors.toList());
    }

    public List<ProjectDTO> getClosedProjects(){
        List<ProjectDTO> ls = getProjectDTOs().stream()
                .filter(ProjectDTO::getClosed)
                .collect(Collectors.toList());
        for(ProjectDTO p:ls){
            float curMoney = findCurMoneyOfProjectById(p.getPRJ_ID());
            float movedMoney = findMovedMoneyOfClosedProject(p.getPRJ_ID());
            p.setMoveMoneyProgress(round(movedMoney/curMoney*100,1));
        }
        return ls;
    }

    public List<ProjectDTO> createProject(ProjectDTO p,Integer collaboratorId){
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
        np.setCity(this.cityRepository.findById(p.getCti_ID()).orElseThrow());
        np.setCollaborator(this.collaboratorService.findById(collaboratorId));
        np.setProjectImages(this.projectImagesService.createListProjectImage(np,p.getImages()));
        np.setVerified(collaboratorId == 0);
        np.setDisbursed(false);
        np.setClosed(false);
        this.repo.saveAndFlush(np);
        if(collaboratorId == 0){
            this.donatorNotificationService.saveAndPushNotificationToAllUser(np.getPRJ_ID(),"new");
            return this.getProjectDTOsWhereUncloseAndVerifiedFromAToB(0,5);
        }else{
            return getUncloseProjectDTOsByCollaboratorIdFromAToB(collaboratorId,0,5);
        }
    }

    public List<ProjectDTO> updateProject(ProjectDTO p,Integer collaboratorId) {
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
        np.setCity(this.cityRepository.findById(p.getCti_ID()).orElseThrow());
        this.projectImagesService.updateListProjectImage(np,p.getImages());
        this.repo.saveAndFlush(np);
        if(collaboratorId == 0){
            return this.getProjectDTOsWhereUncloseAndVerifiedFromAToB(0,5);
        }else{
            return getUncloseProjectDTOsByCollaboratorIdFromAToB(collaboratorId,0,5);
        }
    }

    public List<ProjectDTO> getProjectsByCollaboratorId(Integer id) {
       return getProjectDTOs().stream()
                .filter(p-> !p.getClosed())
                .filter(p-> p.getCollaborator().getCLB_ID().equals(id))
                .sorted(Comparator.comparing(ProjectDTO::getUpdateTime).reversed())
                .collect(Collectors.toList());
    }
}

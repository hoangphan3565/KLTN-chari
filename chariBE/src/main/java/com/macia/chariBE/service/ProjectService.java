package com.macia.chariBE.service;

//import com.macia.chariBE.DTO.Project.ProjectDTOForAdmin;
import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.ICityRepository;
import com.macia.chariBE.repository.IJwtUserRepository;
import com.macia.chariBE.repository.IProjectRepository;
import com.macia.chariBE.repository.IPushNotificationRepository;
import com.macia.chariBE.utility.EDonateDetailsStatus;
import com.macia.chariBE.utility.ENotificationTopic;
import com.macia.chariBE.utility.EProjectStatus;
import com.macia.chariBE.utility.NumberUtility;
import net.minidev.json.JSONObject;
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

import static com.macia.chariBE.utility.Round.round;

@Service
public class ProjectService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private IProjectRepository repo;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private IPushNotificationRepository pushNotificationRepository;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private IJwtUserRepository jwtUserRepository;

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
    private ICityRepository ICityRepository;

    @Autowired
    private CollaboratorService collaboratorService;


    @Autowired
    private ICityRepository cityRepository;


    // Basic Service
    public void save(Project project) {
        repo.saveAndFlush(project);
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
    // End - Basic Service

    // find the attribute for DTO
    public int findCurMoneyOfProject(Project p){
        int curMoney = 0;
        List<DonateActivity> donateActivityList = donateActivityService.findByProjectID(p.getPRJ_ID());
        if(!donateActivityList.isEmpty()){
            for(DonateActivity da:donateActivityList){
                List<DonateDetails> donateDetailsList = donateDetailsService.findDonateDetailByDonateActivityId(da.getDNA_ID());
                for(DonateDetails dd: donateDetailsList){
                    if(dd.getStatus().equals(EDonateDetailsStatus.SUCCESSFUL.toString())){
                        curMoney+=dd.getMoney();
                    }

                }
            }
        }
        return curMoney;
    }
    public int findCurMoneyOfProjectById(Integer id){
        int curMoney = 0;
        List<DonateActivity> donateActivityList = donateActivityService.findByProjectID(id);
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
        List<DonateActivity> donateActivityList = donateActivityService.findByProjectID(p.getPRJ_ID());
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
    public Integer findNumOfPostOfProject(Integer id){
        TypedQuery<Post> query = em.createNamedQuery("named.post.findByProjectId", Post.class);
        query.setParameter("id",id);
        return query.getResultList().size();
    }
    public long findRemainingTermOfProject(Project p){
        return ChronoUnit.DAYS.between(LocalDate.now(), p.getEndDate());
    }
    public EProjectStatus findStatusOfProject(Project p){
        int curMoney = this.findCurMoneyOfProject(p);
        long remainingTerm = this.findRemainingTermOfProject(p);
        if(curMoney>=p.getTargetMoney()){
            return EProjectStatus.REACHED;
        }else{
            if(remainingTerm<=0){
                return EProjectStatus.OVERDUE;
            }
        }
        return EProjectStatus.ACTIVATING;
    }
    private double findAchieved(Project p){
        return round(findCurMoneyOfProject(p)/p.getTargetMoney().doubleValue()*100,1);
    }
    public int findMovedMoneyOfClosedProject(Integer prjid){
        int money=0;
        List<DonateActivity> donateActivities = donateActivityService.findByProjectID(prjid);
        for(DonateActivity da:donateActivities){
            List<DonateDetails> donateDetails = da.getDonateDetails();
            for(DonateDetails details: donateDetails){
                if(details.getStatus().equals(EDonateDetailsStatus.MOVED.toString())){
                    money+=details.getMoney();
                }
            }
        }
        return money;
    }
    // End - find the attribute for DTO

    private ProjectDTO mapToDTO(Project p){
        return ProjectDTO.builder()
                .PRJ_ID(p.getPRJ_ID()).projectCode(p.getProjectCode()).projectName(p.getProjectName())
                .briefDescription(p.getBriefDescription()).description(p.getDescription())
                .imageUrl(p.getImageUrl()).videoUrl(p.getVideoUrl())
                .images(this.projectImagesService.findListStringProjectImagesByProjectId(p.getPRJ_ID()))
                .targetMoney(p.getTargetMoney()).curMoney(Integer.valueOf(String.valueOf(findCurMoneyOfProject(p))))
                .achieved(findAchieved(p)).numOfDonations(findNumOfDonationOfProject(p)).numOfPost(findNumOfPostOfProject(p.getPRJ_ID()))
                .startDate(p.getStartDate().toString()).endDate(p.getEndDate().toString())
                .remainingTerm(Long.valueOf(String.valueOf(findRemainingTermOfProject(p))))
                .verified(p.getVerified()).status(p.getStatus()).disbursed(p.getDisbursed()).closed(p.getClosed())
                .prt_ID(p.getProjectType().getPRT_ID()).projectType(p.getProjectType())
                .stp_ID(p.getSupportedPeople().getSTP_ID()).supportedPeople(p.getSupportedPeople())
                .clb_ID(p.getCollaborator().getCLB_ID()).collaborator(p.getCollaborator())
                .cti_ID(p.getCity().getCTI_ID()).city(p.getCity())
                .build();
    }

    // Services for Collaborator(Only show Unclose Project Of them)

    public int countAllProjectOfCollaborator(Integer id) {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findVerifiedByCollaboratorId", Project.class);
        query.setParameter("id", id);
        return query.getResultList().size();
    }

    public int countTotalMoneyAllProjectOfCollaborator(Integer id) {
        int money=0;
        TypedQuery<Project> query = em.createNamedQuery("named.project.findVerifiedByCollaboratorId", Project.class);
        query.setParameter("id", id);
        List<Project> ls = query.getResultList();
        for(Project p:ls){
            money+=findCurMoneyOfProject(p);
        }
        return  money;
    }

    public Integer countAllUnverifiedByCollaboratorId(Integer id) {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUnVerifiedByCollaboratorId", Project.class);
        query.setParameter("id", id);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getUnverifiedProjectDTOsByCollaboratorIdPageASizeB(Integer id,Integer a,Integer b){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUnVerifiedByCollaboratorId", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        query.setParameter("id", id);
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }

    public int countAllWhereActivatingByCollaboratorId(Integer clb_id){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findActivatingByCollaboratorId", Project.class);
        query.setParameter("id", clb_id);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getActivatingProjectDTOsByCollaboratorId(Integer clb_id,Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findActivatingByCollaboratorId", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        query.setParameter("id", clb_id);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }

    public int countAllWhereReachedByCollaboratorId(Integer clb_id){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findReachedByCollaboratorId", Project.class);
        query.setParameter("id", clb_id);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getReachedProjectDTOsByCollaboratorId(Integer clb_id,Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findReachedByCollaboratorId", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        query.setParameter("id", clb_id);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }

    public int countAllWhereOverdueByCollaboratorId(Integer clb_id){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findOverdueByCollaboratorId", Project.class);
        query.setParameter("id", clb_id);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getOverdueProjectDTOsByCollaboratorId(Integer clb_id,Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findOverdueByCollaboratorId", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        query.setParameter("id", clb_id);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }

    public Integer countCloseByCollaboratorId(Integer id) {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findClosedByCollaboratorId", Project.class);
        query.setParameter("id", id);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getClosedProjectsOfCollaborator(Integer id,Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findClosedByCollaboratorId", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        query.setParameter("id", id);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        for(ProjectDTO p:ls){
            float curMoney = findCurMoneyOfProjectById(p.getPRJ_ID());
            float movedMoney = findMovedMoneyOfClosedProject(p.getPRJ_ID());
            p.setMoveMoneyProgress(round(movedMoney/curMoney*100,1));
        }
        return ls;
    }
    // End - Services for Collaborator(Only show Unclose Project Of them)



    // Services for Admin(Verified and Unclose Project)
    public Integer countAllWhereUncloseAndVerified() {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUncloseAndVerified", Project.class);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getProjectDTOsWhereUncloseAndVerifiedPageASizeB(Integer a,Integer b){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUncloseAndVerified", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }
    //Only show Verified and Unclose Project


    // Search service for Donator
    public List<ProjectDTO> getProjectDTOsUncloseAndVerifiedByName(String name){
        List<ProjectDTO> r = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUncloseAndVerifiedByName", Project.class);
        query.setParameter("name", "%" + name.toLowerCase() + "%");
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }
    // End - Service for Donator

    //Another service
    public String getImageUrlOfProjectById(Integer id){
        return findProjectById(id).getImageUrl();
    }




    // Handle a project=====================================================================
    public JSONObject approveProject(Integer id){
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            Project p = repo.findById(id).orElseThrow();
            p.setVerified(true);
            repo.saveAndFlush(p);
            donatorNotificationService.saveAndPushNotificationToAllUser(p, ENotificationTopic.NEW);
            jso.put("errorCode",0);
            jso.put("data",getUnverifiedProjects(0,5));
            jso.put("message","Duyệt dự án thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("data",getUnverifiedProjects(0,5));
            jso.put("message","Duyệt thất bại! Dự án đã bị xoá trước đó!");
        }
        return jso;
    }
    public JSONObject closeProject(Integer id){
        JSONObject jso = new JSONObject();
        PushNotification pn = this.pushNotificationRepository.findByTopic(ENotificationTopic.CLOSED);
        Project p = findProjectById(id);
        if(repo.findById(id).isPresent()){
            if(!p.getClosed()){
                if(!p.getProjectType().getCanDisburseWhenOverdue()){
                    donatorNotificationService.saveAndPushNotificationToUsers(pn,id);
                    p.setClosed(true);
                    repo.saveAndFlush(p);
                    jso.put("errorCode",0);
                    jso.put("message","Đóng dự án thành công!");
                }else{
                    if(!p.getDisbursed()){
                        jso.put("errorCode",1);
                        jso.put("message","Dự án này chưa giải ngân, không thể đóng!");
                    }else{
                        p.setClosed(true);
                        repo.saveAndFlush(p);
                        jso.put("errorCode",0);
                        jso.put("message","Đóng dự án thành công!");
                    }
                }
            }else{
                jso.put("errorCode",1);
                jso.put("message","Dự án đã được đóng trước đó");
            }
        }else{
            jso.put("errorCode",1);
            jso.put("message","Đã xảy ra lỗi! Không tìm thấy dự án");
        }
        return jso;
    }

    public JSONObject extendProject(Integer id,Integer nod){
        JSONObject jso = new JSONObject();
        Project p = repo.findById(id).orElseThrow();
        if(p.getStatus().equals(EProjectStatus.OVERDUE)){
            p.setEndDate(LocalDate.now().plusDays(nod));
            p.setStatus(EProjectStatus.ACTIVATING);
            repo.saveAndFlush(p);
            jso.put("errorCode",0);
            jso.put("message","Gia hạn dự án thành công!");
            PushNotification pn = this.pushNotificationRepository.findByTopic(ENotificationTopic.EXTENDED);
            donatorNotificationService.saveAndPushNotificationToUsers(pn,id);
        }else{
            jso.put("errorCode",1);
            jso.put("message","Dự án đã được gia hạn trước đó!");
        }
        return jso;
    }

    public JSONObject createProject(ProjectDTO p,Integer collaboratorId){
        JSONObject jso = new JSONObject();
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
        np.setStatus(EProjectStatus.ACTIVATING);
        this.repo.saveAndFlush(np);
        if(collaboratorId == 0){
            this.donatorNotificationService.saveAndPushNotificationToAllUser(np,ENotificationTopic.NEW);
        }
        jso.put("errorCode", 0);
        jso.put("message", "Thêm dự án thành công!");
        return jso;
    }
    public JSONObject updateProject(ProjectDTO p) {
        Project np = this.findProjectById(p.getPRJ_ID());
        JSONObject jso = new JSONObject();
        if(np!=null){
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
            jso.put("errorCode", 0);
            jso.put("message", "Cập nhật dự án thành công!");
        }else{
            jso.put("errorCode", 1);
            jso.put("message", "Cập nhật thất bại, dự án đã bị xoá trước đó!");
        }
        return jso;
    }
    public JSONObject updateAndApprove(ProjectDTO p) {
        JSONObject jso = new JSONObject();
        Project np = this.findProjectById(p.getPRJ_ID());
        if(np!=null){
            np.setProjectName(p.getProjectName());
            np.setBriefDescription(p.getBriefDescription());
            np.setDescription(p.getDescription());
            np.setStartDate(LocalDate.parse(p.getStartDate().split("T")[0]));
            np.setEndDate(LocalDate.parse(p.getEndDate().split("T")[0]));
            np.setTargetMoney(p.getTargetMoney());
            np.setImageUrl(p.getImageUrl());
            np.setVideoUrl(p.getVideoUrl());
            np.setVerified(true);
            np.setProjectType(this.projectTypeService.findById(p.getPrt_ID()));
            np.setSupportedPeople(this.supportedPeopleService.findById(p.getStp_ID()));
            np.setCity(this.cityRepository.findById(p.getCti_ID()).orElseThrow());
            this.projectImagesService.updateListProjectImage(np,p.getImages());
            this.repo.saveAndFlush(np);
            this.donatorNotificationService.saveAndPushNotificationToAllUser(np,ENotificationTopic.NEW);
            np.setStatus(EProjectStatus.ACTIVATING);
            jso.put("errorCode", 0);
            jso.put("message", "Phê duyệt thành công!");
        }else{
            jso.put("errorCode", 1);
            jso.put("message", "Phê duyệt thất bại, dự án đã bị xoá trước đó!");
        }
        return jso;
    }
    public JSONObject deleteProjectByID(Integer id) {
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            this.repo.deleteById(id);
            jso.put("errorCode",0);
            jso.put("message","Xoá dự án thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("message","Dự án đã bị xoá trước đó!");
        }
        return jso;
    }
    // End - Handle a project =============================================================


    public ProjectDTO getProjectDTOById(Integer id){
        Project p = this.findProjectById(id);
        return mapToDTO(p);
    }


    // Services for Admin
    public int countTotalMoney() {
        int money=0;
        List<Project> ls = this.findAll();
        for(Project p:ls){
            money+=findCurMoneyOfProject(p);
        }
        return  money;
    }

    public int countAllWhereActivating(){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findActivating", Project.class);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getActivatingProjectDTOs(Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findActivating", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }

    public List<ProjectDTO> getAllActivatingProjectDTOs(){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findActivating", Project.class);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }
    public List<ProjectDTO> getProjectReadyToMoveMoney(int money){
        return this.getAllActivatingProjectDTOs().stream()
                .filter(p->p.getTargetMoney()-p.getCurMoney()>=money)
                .collect(Collectors.toList());
    }

    public int countAllWhereReached(){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findReached", Project.class);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getReachedProjectDTOs(Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findReached", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }

    public int countAllWhereOverdue(){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findOverdue", Project.class);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getOverdueProjectDTOs(Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findOverdue", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        return ls;
    }

    public int countAllWhereClosed(){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findClosed", Project.class);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getClosedProjects(Integer a,Integer b){
        List<ProjectDTO> ls = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findClosed", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            ls.add(mapToDTO(p));
        }
        for(ProjectDTO p:ls){
            float curMoney = findCurMoneyOfProjectById(p.getPRJ_ID());
            if(curMoney>0){
                float movedMoney = findMovedMoneyOfClosedProject(p.getPRJ_ID());
                p.setMoveMoneyProgress(round(movedMoney/curMoney*100,1));
            }
        }
        return ls;
    }

    public int countAllWhereUnverified(){
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUnVerified", Project.class);
        return query.getResultList().size();
    }
    public List<ProjectDTO> getUnverifiedProjects(Integer a,Integer b){
        List<ProjectDTO> r = new ArrayList<>();
        TypedQuery<Project> query = em.createNamedQuery("named.project.findUnVerified", Project.class)
                .setFirstResult(a*b).setMaxResults(b);
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }






    //===================================== Filter ==================================//
    // function get List Id
    public List<Integer> getAllCityId(){
        List<Integer> r = new ArrayList<>();
        List<City> cities = cityRepository.findAll();
        for(City c:cities){
            r.add(c.getCTI_ID());
        }
        return  r;
    }
    public List<Integer> getAllProjectTypeId(){
        List<Integer> r = new ArrayList<>();
        List<ProjectType> typeList = projectTypeService.findAll();
        for(ProjectType p:typeList){
            r.add(p.getPRT_ID());
        }
        return  r;
    }
    public List<Integer> getAllProjectId(){
        List<Integer> r = new ArrayList<>();
        List<Project> ps = findAll();
        for(Project p:ps){
            r.add(p.getPRJ_ID());
        }
        return  r;
    }


    // service for Donator(Only show Verified and Unclose) and apply filter + search
    public List<ProjectDTO> getProjectsByMultiFilterAndSearchKey(String did, List<String> c_ids, List<String> pt_ids, List<String> status, String key,Integer page,Integer size) {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findProjectMultiFilterAndSearchKey", Project.class)
                .setFirstResult(page*size).setMaxResults(size);
        if(!did.equals("*")){
            Donator donator = donatorService.findById(Integer.valueOf(did));
            if(donator.getFavoriteProject().equals("")){
                query.setParameter("ids", -1);
            }else{
                String[] curFavoriteList = donator.getFavoriteProject().split(" ");
                List<Integer> id = new ArrayList<>();
                for (String s : curFavoriteList) {
                    id.add(Integer.valueOf(s));
                }
                query.setParameter("ids", id);
            }
        }else{
            query.setParameter("ids", getAllProjectId());
        }

        if(pt_ids.contains("*")){
            query.setParameter("ptids", getAllProjectTypeId());
        }else{
            query.setParameter("ptids", NumberUtility.convertStringListToIntList(pt_ids, Integer::parseInt));
        }

        if(c_ids.contains("*")){
            query.setParameter("cids", getAllCityId());
        }else{
            query.setParameter("cids", NumberUtility.convertStringListToIntList(c_ids, Integer::parseInt));
        }

        if(key.equals("*")){
            query.setParameter("name", "%"+""+"%");
        }else{
            query.setParameter("name", "%" + key.toLowerCase() + "%");
        }

        if(!status.contains("*")){
            List<EProjectStatus> statuses = new ArrayList<>();
            for(String s:status){
                statuses.add(EProjectStatus.valueOf(s));
            }
            query.setParameter("status",statuses);
        }else{
            List<EProjectStatus> statuses = new ArrayList<>();
            statuses.add(EProjectStatus.ACTIVATING);
            statuses.add(EProjectStatus.REACHED);
            statuses.add(EProjectStatus.OVERDUE);
            query.setParameter("status", statuses);
        }

        List<ProjectDTO> r = new ArrayList<>();
        List<Project> ps = query.getResultList();
        for(Project p : ps){
            r.add(mapToDTO(p));
        }
        return r;
    }

    public int countTotalProjectsByMultiFilterAndSearchKey(String did, List<String> c_ids, List<String> pt_ids, List<String> status, String key) {
        TypedQuery<Project> query = em.createNamedQuery("named.project.findProjectMultiFilterAndSearchKey", Project.class);
        if(!did.equals("*")){
            Donator donator = donatorService.findById(Integer.valueOf(did));
            if(donator.getFavoriteProject().equals("")){
                query.setParameter("ids", -1);
            }else{
                String[] curFavoriteList = donator.getFavoriteProject().split(" ");
                List<Integer> id = new ArrayList<>();
                for (String s : curFavoriteList) {
                    id.add(Integer.valueOf(s));
                }
                query.setParameter("ids", id);
            }
        }else{
            query.setParameter("ids", getAllProjectId());
        }

        if(pt_ids.contains("*")){
            query.setParameter("ptids", getAllProjectTypeId());
        }else{
            query.setParameter("ptids", NumberUtility.convertStringListToIntList(pt_ids, Integer::parseInt));
        }

        if(c_ids.contains("*")){
            query.setParameter("cids", getAllCityId());
        }else{
            query.setParameter("cids", NumberUtility.convertStringListToIntList(c_ids, Integer::parseInt));
        }

        if(key.equals("*")){
            query.setParameter("name", "%"+""+"%");
        }else{
            query.setParameter("name", "%" + key.toLowerCase() + "%");
        }

        if(!status.contains("*")){
            List<EProjectStatus> statuses = new ArrayList<>();
            for(String s:status){
                statuses.add(EProjectStatus.valueOf(s));
            }
            query.setParameter("status",statuses);
        }else{
            List<EProjectStatus> statuses = new ArrayList<>();
            statuses.add(EProjectStatus.ACTIVATING);
            statuses.add(EProjectStatus.REACHED);
            statuses.add(EProjectStatus.OVERDUE);
            query.setParameter("status", statuses);
        }
        return query.getResultList().size();
    }


    //*** update all project status
    public void updateAllProjectStatus(){
        List<Project> ls = findAll();
        if(!ls.isEmpty()){
            for(Project p:ls){
                p.setStatus(findStatusOfProject(p));
            }
        }
        repo.saveAll(ls);
    }


    public Object disburseFund() {
        JSONObject jso = new JSONObject();
        List<ProjectDTO> activatingProject = getAllActivatingProjectDTOs().stream().filter(p->p.getPRJ_ID()!=0).collect(Collectors.toList());
        if(activatingProject.isEmpty()){
            jso.put("errorCode",1);
            jso.put("message","Không còn dự án nào khác đang hoạt động");
        }else{
            Project fund = findProjectById(0);
            int curFund = findCurMoneyOfProject(fund);
            int divFund = curFund/activatingProject.size();
            Donator chari = donatorService.findByUsername("chari");
            PushNotification pn = pushNotificationRepository.findByTopic(ENotificationTopic.FUND);
            if(curFund>0){
                List<DonateActivity> listDA = donateActivityService.findByProjectID(0);
                for(DonateActivity da:listDA){
                    List<DonateDetails> detailsList =  da.getDonateDetails();
                    for(DonateDetails dd:detailsList){
                        if(dd.getStatus().equals(EDonateDetailsStatus.SUCCESSFUL.toString())){
                            dd.setStatus(EDonateDetailsStatus.MOVED.toString());
                        }
                    }
                }
                donatorNotificationService.saveAndPushNotificationToUsers(pn,0);
                for(ProjectDTO p:activatingProject){
                    donateDetailsService.saveDonateDetails(chari.getDNT_ID(),p.getPRJ_ID(),divFund,LocalDateTime.now());
                }
                jso.put("errorCode",0);
                jso.put("message","Đã chia quỹ chung tới tất cả dự án đang hoạt động");
                updateAllProjectStatus();
            }else{
                jso.put("errorCode",1);
                jso.put("message","Quỹ chung đã hết");
            }
        }

        return jso;
    }
}

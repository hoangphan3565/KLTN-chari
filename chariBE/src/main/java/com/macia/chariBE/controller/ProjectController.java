package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.Project.ProjectDTOForAdmin;
import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.repository.PushNotificationRepository;
import com.macia.chariBE.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/projects")
public class ProjectController {
    @Autowired
    private ProjectService projectService;

    @Autowired
    private ProjectTypeService projectTypeService;

    @Autowired
    private SupportedPeopleService supportedPeopleService;

    @Autowired
    private PushNotificationController pushNotificationController;

    @Autowired
    private PushNotificationRepository pushNotificationRepository;

    @Autowired
    private DonatorNotificationService donatorNotificationService;

    @Autowired
    private DonatorService donatorService;

    @Autowired
    private DonateActivityService donateActivityService;

    @GetMapping("/{id}")
    public ResponseEntity<?> getProjectByID(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(projectService.findProjectById(id));
    }

    @GetMapping()
    public ResponseEntity<?> getAllProjectDTO() {
        return ResponseEntity.ok().body(projectService.getProjectDTOs());
    }

    @GetMapping("/project_type/{id}")
    public ResponseEntity<?> getProjectByProjectTypeId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(projectService.findProjectByProjectTypeId(id));
    }

    @GetMapping("/activating")
    public ResponseEntity<?> getActivatingProjectDTO() {
        return ResponseEntity.ok().body(projectService.getActivatingProjectDTOs());
    }

    @GetMapping("/overdue")
    public ResponseEntity<?> getOverdueProjectDTO() {
        return ResponseEntity.ok().body(projectService.getOverdueProjectDTOs());
    }

    @GetMapping("/reached")
    public ResponseEntity<?> getReachedProjectDTO() {
        return ResponseEntity.ok().body(projectService.getReachedProjectDTOs());
    }
    @GetMapping("/closed")
    public ResponseEntity<?> getClosedProjectDTO() {
        return ResponseEntity.ok().body(projectService.getClosedProjects());
    }

    @GetMapping("/plain")
    public ResponseEntity<?> getAllProject() {
        return ResponseEntity.ok().body(projectService.getVerifiedProjects());
    }

    @GetMapping("/plain-unverified")
    public ResponseEntity<?> getUnverifiedProject() {
        return ResponseEntity.ok().body(projectService.getUnverifiedProjects());
    }
    @GetMapping("/dto_for_admin")
    public ResponseEntity<?> getAllProjectDTOForAdmin() {
        return ResponseEntity.ok().body(projectService.getProjectDTOForAdmin());
    }

    @PutMapping("/approve/{id}")
    public ResponseEntity<?> approveProject(@PathVariable(value = "id") Integer id) {
        NotificationObject no = new NotificationObject();
        PushNotification pn = this.pushNotificationRepository.findByTopic("new");
        no.setTitle(pn.getTitle());
        no.setMessage(pn.getMessage());
        no.setTopic(pn.getTopic());
        List<Donator> donators = this.donatorService.findAll();
        for(Donator d:donators){
            donatorNotificationService.save(DonatorNotification.builder()
                    .topic(pn.getTopic())
                    .title(pn.getTitle())
                    .message(pn.getMessage())
                    .create_time(LocalDateTime.now())
                    .is_read(false)
                    .is_handled(false)
                    .donator(d)
                    .project_id(id).build());
        }
        this.pushNotificationController.pushNotificationWithoutDataToTopic(no);

        return ResponseEntity.ok().body(projectService.approveProject(id));
    }

    @PutMapping("/close/{id}")
    public ResponseEntity<?> closeProject(@PathVariable(value = "id") Integer id) {
        NotificationObject no = new NotificationObject();
        PushNotification pn = this.pushNotificationRepository.findByTopic("closed");
        no.setTitle(pn.getTitle());
        no.setMessage(pn.getMessage());
        no.setTopic(pn.getTopic());
        List<DonateActivity> listDA = this.donateActivityService.findDonateActivityByProjectID(id);
        for(DonateActivity lda:listDA){
            donatorNotificationService.save(DonatorNotification.builder()
                    .topic(pn.getTopic())
                    .title(pn.getTitle())
                    .message(pn.getMessage())
                    .create_time(LocalDateTime.now())
                    .is_read(false)
                    .is_handled(false)
                    .donator(lda.getDonator())
                    .project_id(id).build());
        }
        this.pushNotificationController.pushNotificationWithoutDataToTopic(no);
        return ResponseEntity.ok().body(projectService.closeProject(id));
    }

    @PutMapping("/extend/{id}/num_of_date/{nod}")
    public ResponseEntity<?> extendProjectDeadline(
            @PathVariable(value = "id") Integer id,
            @PathVariable(value = "nod") Integer nod) {
        NotificationObject no = new NotificationObject();
        PushNotification pn = this.pushNotificationRepository.findByTopic("extended");
        no.setTitle(pn.getTitle());
        no.setMessage(pn.getMessage());
        no.setTopic(pn.getTopic());
        List<DonateActivity> listDA = this.donateActivityService.findDonateActivityByProjectID(id);
        for(DonateActivity lda:listDA){
            donatorNotificationService.save(DonatorNotification.builder()
                    .topic(pn.getTopic())
                    .title(pn.getTitle())
                    .message(pn.getMessage())
                    .create_time(LocalDateTime.now())
                    .is_read(false)
                    .is_handled(false)
                    .donator(lda.getDonator())
                    .project_id(id).build());
        }
        this.pushNotificationController.pushNotificationWithoutDataToTopic(no);
        return ResponseEntity.ok().body(projectService.extendProject(id,nod));
    }

    @PostMapping("/create/is_admin/{isadmin}")
    public ResponseEntity<?> create(
            @RequestBody ProjectDTOForAdmin project,
            @PathVariable(value = "isadmin") Boolean isAdmin) {
        return ResponseEntity.ok().body(projectService.createProject(project,isAdmin));
    }

}

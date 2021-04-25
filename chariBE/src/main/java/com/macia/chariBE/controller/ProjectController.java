package com.macia.chariBE.controller;

import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.repository.PushNotificationRepository;
import com.macia.chariBE.repository.PushNotificationTopicRepository;
import com.macia.chariBE.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

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

    @GetMapping("/{id}")
    public ResponseEntity<?> getProjectByID(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(projectService.findProjectById(id));
    }

    @GetMapping()
    public ResponseEntity<?> getAllProjectDTO() {
        return ResponseEntity.ok().body(projectService.getProjectDTOs());
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

    @GetMapping("/plain")
    public ResponseEntity<?> getAllProject() {
        return ResponseEntity.ok().body(projectService.getAllProjects());
    }

    @GetMapping("/plain-unverified")
    public ResponseEntity<?> getUnverifiedProject() {
        return ResponseEntity.ok().body(projectService.getUnverifiedProjects());
    }

    @PutMapping("/approve/{id}")
    public ResponseEntity<?> approveProject(@PathVariable(value = "id") Integer id) {
        NotificationObject no = new NotificationObject();
        PushNotification pn = this.pushNotificationRepository.findById(1).orElseThrow();
        no.setTitle(pn.getTitle());
        no.setMessage(pn.getMessage());
        no.setTopic(pn.getNotificationTopic().getTopicName());
        List<Donator> donators = this.donatorService.findAll();
        for(Donator d:donators){
            donatorNotificationService.save(DonatorNotification.builder()
                    .title(pn.getTitle())
                    .message(pn.getMessage())
                    .createTime(LocalDateTime.now())
                    .donator(d)
                    .projectID(id).build());
        }
        this.pushNotificationController.pushNotificationWithoutDataToTopic(no);

        return ResponseEntity.ok().body(projectService.approveProject(id));
    }

    @PostMapping("/create/type/{prtid}/peo/{sptid}")
    public ResponseEntity<?> create(
            @RequestBody Project project,
            @PathVariable(value = "prtid") Integer prtid,
            @PathVariable(value = "sptid") Integer sptid) {
        ProjectType projectType = projectTypeService.findById(prtid);
        project.setProjectType(projectType);
        SupportedPeople supportedPeople = supportedPeopleService.findById(sptid);
        project.setSupportedPeople(supportedPeople);
        return ResponseEntity.ok().body(projectService.save(project));
    }
}

package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.*;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.JwtUserRepository;
import com.macia.chariBE.repository.PushNotificationRepository;
import com.macia.chariBE.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/projects")
public class ProjectController {
    @Autowired
    private ProjectService projectService;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private PushNotificationRepository pushNotificationRepository;

    @Autowired
    private DonatorNotificationService donatorNotificationService;

    @Autowired
    private DonatorService donatorService;

    @Autowired
    private DonateActivityService donateActivityService;

    @Autowired
    private JwtUserRepository jwtUserRepository;


    @GetMapping("/{id}")
    public ResponseEntity<?> getProjectByID(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(projectService.findProjectById(id));
    }

    @GetMapping()
    public ResponseEntity<?> getAllProjectDTO() {
        return ResponseEntity.ok().body(projectService.getProjectDTOs().stream()
                .sorted(Comparator.comparing(ProjectDTO::getPriorityPoint).reversed())
                .collect(Collectors.toList()));
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

    @GetMapping("/ready_to_move_money/{money}")
    public ResponseEntity<?> getProjectReadyToMoveMoney(@PathVariable(value = "money") Integer money) {
        return ResponseEntity.ok().body(projectService.getProjectReadyToMoveMoney(money));
    }

    @GetMapping("/verified")
    public ResponseEntity<?> getAllProject() {
        return ResponseEntity.ok().body(projectService.getVerifiedProjects());
    }

    @GetMapping("/unverified")
    public ResponseEntity<?> getUnverifiedProject() {
        return ResponseEntity.ok().body(projectService.getUnverifiedProjects());
    }

    @PutMapping("/approve/{id}")
    public ResponseEntity<?> approveProject(@PathVariable(value = "id") Integer id) {
        donatorNotificationService.saveAndPushNotificationToAllUser(id,"new");
        return ResponseEntity.ok().body(projectService.approveProject(id));
    }

    @PutMapping("/close/{id}")
    public ResponseEntity<?> closeProject(@PathVariable(value = "id") Integer id) {
        PushNotification pn = this.pushNotificationRepository.findByTopic("closed");
        if(!projectService.findProjectById(id).getProjectType().getCanDisburseWhenOverdue()){
            donatorNotificationService.saveAndPushNotificationToUser(pn,id);
        }
        return ResponseEntity.ok().body(projectService.closeProject(id));
    }

    @PutMapping("/handle_all_money")
    public ResponseEntity<?> handleAllCloseAndUnHandled() {
        donatorNotificationService.handleAllMoneyOfClosedProjectOverSevenDay();
        return ResponseEntity.ok().body(projectService.getClosedProjects());
    }

    @PutMapping("/extend/{id}/num_of_date/{nod}")
    public ResponseEntity<?> extendProjectDeadline(
            @PathVariable(value = "id") Integer id,
            @PathVariable(value = "nod") Integer nod) {
        PushNotification pn = this.pushNotificationRepository.findByTopic("extended");
        donatorNotificationService.saveAndPushNotificationToUser(pn,id);
        return ResponseEntity.ok().body(projectService.extendProject(id,nod));
    }

    @PostMapping("/create/is_admin/{isadmin}")
    public ResponseEntity<?> create(
            @RequestBody ProjectDTO project,
            @PathVariable(value = "isadmin") Boolean isAdmin) {
        return ResponseEntity.ok().body(projectService.createProject(project,isAdmin));
    }

    @PutMapping("/update")
    public ResponseEntity<?> update(
            @RequestBody ProjectDTO project) {
        return ResponseEntity.ok().body(projectService.updateProject(project));
    }

}

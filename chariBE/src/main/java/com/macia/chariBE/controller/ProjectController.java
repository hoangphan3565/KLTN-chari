package com.macia.chariBE.controller;

import com.macia.chariBE.model.Project;
import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.model.SupportedPeople;
import com.macia.chariBE.service.ProjectService;
import com.macia.chariBE.service.ProjectTypeService;
import com.macia.chariBE.service.SupportedPeopleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
        return ResponseEntity.ok().body(projectService.getUnverifiedProjects());
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

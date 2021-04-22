package com.macia.chariBE.controller;

import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.service.ProjectTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/project_types")
public class ProjectTypeController {

    @Autowired
    ProjectTypeService projectTypeService;

    @GetMapping()
    public List<ProjectType> getAllProjectType() {
        return projectTypeService.findAll();
    }
    @GetMapping("/{id}")
    public ProjectType getProjectTypeById(@PathVariable(value = "id") Integer id) {
        return projectTypeService.findById(id);
    }
    @PostMapping()
    public List<ProjectType> saveProjectType(@RequestBody ProjectType pt) {
        projectTypeService.save(pt);
        return projectTypeService.findAll();
    }
    @PutMapping("/{id}")
    public List<ProjectType> updateProjectType(@PathVariable(value = "id") Integer id, @RequestBody ProjectType pt) {
        ProjectType p = projectTypeService.findById(id);
        p.setProjectTypeName(pt.getProjectTypeName());
        projectTypeService.save(p);
        return projectTypeService.findAll();
    }

    @DeleteMapping("/{id}")
    public List<ProjectType> removeProjectTypeById(@PathVariable(value = "id") Integer id) {
        projectTypeService.removeById(id);
        return projectTypeService.findAll();
    }
}

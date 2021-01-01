package com.macia.charitysystem.api;

import com.macia.charitysystem.model.ProjectType;
import com.macia.charitysystem.service.ProjectTypeService;
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
    public ProjectType saveProjectType(@RequestBody ProjectType pt) {
        return projectTypeService.save(pt);
    }

    @DeleteMapping("/{id}")
    public void removeProjectTypeById(@PathVariable(value = "id") Integer id) {
        projectTypeService.removeById(id);
    }
}

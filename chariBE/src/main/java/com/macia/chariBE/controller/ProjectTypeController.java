package com.macia.chariBE.controller;

import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.service.ProjectTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/project_types")
public class ProjectTypeController {

    @Autowired
    ProjectTypeService service;

    @GetMapping()
    public List<ProjectType> getAllProjectType() {
        return service.findAll();
    }

    @GetMapping("/count")
    public ResponseEntity<?> countAll() {
        return ResponseEntity.ok().body(service.countAll());
    }
    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getAll(@PathVariable(value = "a") Integer a,
                                    @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.getPerPageAndSize(a-1,b));
    }
    
    @GetMapping("/{id}")
    public ProjectType getProjectTypeById(@PathVariable(value = "id") Integer id) {
        return service.findById(id);
    }
    @PostMapping()
    public List<ProjectType> saveProjectType(@RequestBody ProjectType pt) {
        service.save(pt);
        return service.findAll();
    }
    @PutMapping("/{id}")
    public List<ProjectType> updateProjectType(@PathVariable(value = "id") Integer id, @RequestBody ProjectType pt) {
        ProjectType p = service.findById(id);
        p.setProjectTypeName(pt.getProjectTypeName());
        p.setDescription(pt.getDescription());
        p.setImageUrl(pt.getImageUrl());
        service.save(p);
        return service.findAll();
    }

    @DeleteMapping("/{id}")
    public List<ProjectType> removeProjectTypeById(@PathVariable(value = "id") Integer id) {
        service.removeById(id);
        return service.findAll();
    }
}

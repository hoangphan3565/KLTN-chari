package com.macia.chariBE.controller;

import com.macia.chariBE.service.ProjectImagesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/project_images")
public class ProjectImageController {
    @Autowired
    private ProjectImagesService projectImagesService;

    @GetMapping("/project/{id}")
    public List<String> getProjectByTypeId(@PathVariable(value = "id") Integer id) {
        return projectImagesService.findProjectImagesByProjectId(id);
    }
}

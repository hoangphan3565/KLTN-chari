package com.macia.charitysystem.controller;

import com.macia.charitysystem.DTO.ImageDTO;
import com.macia.charitysystem.service.ProjectImagesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/project_images")
public class ProjectImageController {
    @Autowired
    private ProjectImagesService projectImagesService;

    @GetMapping("/project/{id}")
    public List<String> getProjectByTypeId(@PathVariable(value = "id") Integer id) {
        List<ImageDTO> imgs = projectImagesService.findProjectImagesByProjectId(id);
        List<String> list = new ArrayList<>();
        for (var ImageDTO : imgs) {
            list.add(ImageDTO.getImageUrl());
        }
        return list;
    }
}

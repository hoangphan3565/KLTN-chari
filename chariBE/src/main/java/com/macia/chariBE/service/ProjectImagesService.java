package com.macia.chariBE.service;

import com.macia.chariBE.model.Project;
import com.macia.chariBE.model.ProjectImages;
import com.macia.chariBE.repository.ProjectImagesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

@Service
public class ProjectImagesService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ProjectImagesRepository repo;

    public List<String> findProjectImagesByProjectId(Integer id) {
        TypedQuery<ProjectImages> query = em.createNamedQuery("named.projectImages.findByProjectId", ProjectImages.class);
        query.setParameter("id", id);
        List<ProjectImages> projectImages = query.getResultList();
        List<String> list = new ArrayList<>();
        for (var ImageDTO : projectImages) {
            list.add(ImageDTO.getImageUrl());
        }
        return list;
    }

    public void saveProjectImageToProjectWithListImage(Project p, List<String> images){
        for(String s:images){
            this.repo.saveAndFlush(ProjectImages.builder().project(p).imageUrl(s).build());
        }
    }
}

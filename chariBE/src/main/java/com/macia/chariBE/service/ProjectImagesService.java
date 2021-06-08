package com.macia.chariBE.service;

import com.macia.chariBE.model.Project;
import com.macia.chariBE.model.ProjectImages;
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

    public List<ProjectImages> findProjectImagesByProjectId(Integer id) {
        TypedQuery<ProjectImages> query = em.createNamedQuery("named.projectImages.findByProjectId", ProjectImages.class);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<String> findListStringProjectImagesByProjectId(Integer id) {
        List<ProjectImages> projectImages = findProjectImagesByProjectId(id);
        List<String> list = new ArrayList<>();
        for (var projectImage : projectImages) {
            list.add(projectImage.getImageUrl());
        }
        return list;
    }

    public List<ProjectImages> createListProjectImage(Project p, List<String> images) {
        List<ProjectImages> projectImages = new ArrayList<>();
        if(images!=null){
            for(String s:images){
                projectImages.add(ProjectImages.builder().project(p).imageUrl(s).build());
            }
        }
        return projectImages;
    }
    public void updateListProjectImage(Project p, List<String> images) {
        repo.deleteInBatch(this.findProjectImagesByProjectId(p.getPRJ_ID()));
        if(images!=null){
            for(String s:images){
                repo.saveAndFlush(ProjectImages.builder().project(p).imageUrl(s).build());
            }
        }
    }
}

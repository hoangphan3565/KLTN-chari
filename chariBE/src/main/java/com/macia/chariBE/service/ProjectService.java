package com.macia.chariBE.service;

import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.*;
import java.util.List;

@Service
public class ProjectService {
    @PersistenceContext
    private EntityManager em;
    @Autowired
    private ProjectRepository projectRepo;

    public Project save(Project project) {
        return projectRepo.saveAndFlush(project);
    }
    @SuppressWarnings("unchecked")
    public List<ProjectDTO> findAllProjectDTO() {
        StoredProcedureQuery query = this.em.createNamedStoredProcedureQuery("named_getProjectDTOList");
        query.execute();
        return query.getResultList();
    }
    public Project findProjectById(Integer id) {
        try {
            TypedQuery<Project> query = em.createNamedQuery("named.project.findById", Project.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}

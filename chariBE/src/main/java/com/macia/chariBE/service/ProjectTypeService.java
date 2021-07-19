package com.macia.chariBE.service;

import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.repository.IProjectTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class ProjectTypeService {
    @PersistenceContext
    private EntityManager em;
    @Autowired
    private IProjectTypeRepository repo;
    public List<ProjectType> findAll() {
        TypedQuery<ProjectType> query = em.createNamedQuery("named.projectType.findAll", ProjectType.class);
        return query.getResultList();
    }
    public int countAll() {
        TypedQuery<ProjectType> query = em.createNamedQuery("named.projectType.findAll", ProjectType.class);
        return query.getResultList().size();
    }

    public List<ProjectType> getPerPageAndSize(int a, int b) {
        TypedQuery<ProjectType> query = em.createNamedQuery("named.projectType.findAll", ProjectType.class)
                .setFirstResult(a*b).setMaxResults(b);
        return query.getResultList();
    }

    public ProjectType findById(Integer id) {
        try {
            TypedQuery<ProjectType> query = em.createNamedQuery("named.projectType.findById", ProjectType.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
    public ProjectType save(ProjectType pt) {
        return repo.saveAndFlush(pt);
    }

    public void removeById(Integer id){
        repo.deleteById(id);
    }
}

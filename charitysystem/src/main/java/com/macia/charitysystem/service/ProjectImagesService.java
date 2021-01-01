package com.macia.charitysystem.service;

import com.macia.charitysystem.DTO.ImageDTO;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class ProjectImagesService {
    @PersistenceContext
    private EntityManager em;

    public List<ImageDTO> findProjectImagesByProjectId(Integer id) {
        TypedQuery<ImageDTO> query = em.createNamedQuery("named.projectImages.findByProjectId", ImageDTO.class);
        query.setParameter("id", id);
        return query.getResultList();
    }
}

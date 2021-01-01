package com.macia.charitysystem.service;

import com.macia.charitysystem.model.SupportedPeople;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Service
public class SupportedPeopleService {
    @PersistenceContext
    private EntityManager em;

    public SupportedPeople findById(Integer id) {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedpeople.findById", SupportedPeople.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}

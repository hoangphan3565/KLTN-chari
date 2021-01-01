package com.macia.charitysystem.service;

import com.macia.charitysystem.model.DonateActivity;
import com.macia.charitysystem.repository.DonateActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Service
public class DonateActivityService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private DonateActivityRepository donateAvtRepo;

    public DonateActivity save(DonateActivity donateActivity) {
        return donateAvtRepo.saveAndFlush(donateActivity);
    }

    public DonateActivity findDonateActivityByDonatorIdAndProjectID(Integer donator_id, Integer project_id) {
        try {
            TypedQuery<DonateActivity> query = em.createNamedQuery("named.donate_activity.findByDonatorIdAndProjectId", DonateActivity.class);
            query.setParameter("did", donator_id);
            query.setParameter("pid", project_id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}

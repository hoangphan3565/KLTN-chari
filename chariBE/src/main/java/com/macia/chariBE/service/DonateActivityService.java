package com.macia.chariBE.service;

import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.repository.IDonateActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class DonateActivityService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private IDonateActivityRepository donateAvtRepo;

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

    public List<DonateActivity> findDonateActivityByProjectID(Integer id) {
        try {
            TypedQuery<DonateActivity> query = em.createNamedQuery("named.donate_activity.findByProjectId", DonateActivity.class);
            query.setParameter("id", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<DonateActivity> findByProjectIdAndClosedNonDisburse(Integer id) {
        try {
            TypedQuery<DonateActivity> query = em.createNamedQuery("named.donate_activity.findByProjectIdAndClosedNonDisburse", DonateActivity.class);
            query.setParameter("id", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
}

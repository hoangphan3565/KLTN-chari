package com.macia.chariBE.service;

import com.macia.chariBE.DTO.DonateDetailsDTO;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class DonateDetailsService {
    @PersistenceContext
    private EntityManager em;

    public List<DonateDetailsDTO> findDonateDetailsByDonatorId(Integer donator_id) {
        try {
            TypedQuery<DonateDetailsDTO> query = em.createNamedQuery("named.donate_details.findByDonatorId", DonateDetailsDTO.class);
            query.setParameter("dntid", donator_id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

}

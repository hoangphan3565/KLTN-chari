package com.macia.chariBE.service;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.JwtUser;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class UserService {

    @PersistenceContext
    private EntityManager em;

    public int countAll() {
        TypedQuery<JwtUser> query = em.createNamedQuery("named.user.findAll", JwtUser.class);
        return query.getResultList().size();
    }

    public List<JwtUser> getPerPageAndSize(int a, int b) {
        TypedQuery<JwtUser> query = em.createNamedQuery("named.user.findAll", JwtUser.class)
                .setFirstResult(a*b).setMaxResults(b);
        return query.getResultList();
    }
}

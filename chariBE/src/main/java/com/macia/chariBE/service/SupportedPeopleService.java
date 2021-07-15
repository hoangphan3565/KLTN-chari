package com.macia.chariBE.service;

import com.macia.chariBE.model.Post;
import com.macia.chariBE.model.SupportedPeople;
import com.macia.chariBE.repository.ISupportedPeopleRepository;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class SupportedPeopleService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ISupportedPeopleRepository repo;

    @Autowired
    private CollaboratorService collaboratorService;

    public int countAll() {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedPeople.findAll", SupportedPeople.class);
            return query.getResultList().size();
        } catch (NoResultException e) {
            return -1;
        }
    }

    public List<SupportedPeople> findAllPageAToB(int a,int b) {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedPeople.findAll", SupportedPeople.class)
                    .setFirstResult(a*b).setMaxResults(b);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    public int countByCollaboratorId(int id) {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedPeople.findByCollaboratorId", SupportedPeople.class) ;
            query.setParameter("id", id);
            return query.getResultList().size();
        } catch (NoResultException e) {
            return -1;
        }
    }

    public List<SupportedPeople> findByCollaboratorIdPageAToB(int id,int a,int b) {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedPeople.findByCollaboratorId", SupportedPeople.class)
                    .setFirstResult(a*b).setMaxResults(b);
            query.setParameter("id", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<SupportedPeople> findAllByCollaboratorId(int id) {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedPeople.findByCollaboratorId", SupportedPeople.class);
            query.setParameter("id", id);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }


    public SupportedPeople findById(Integer id) {
        try {
            TypedQuery<SupportedPeople> query = em.createNamedQuery("named.supportedPeople.findById", SupportedPeople.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public JSONObject save(SupportedPeople sp, Integer clb_id) {
        JSONObject jso = new JSONObject();
        SupportedPeople nsp = new SupportedPeople();
        nsp.setSTP_ID(sp.getSTP_ID());
        nsp.setFullName(sp.getFullName());
        nsp.setAddress(sp.getAddress());
        nsp.setBankName(sp.getBankName());
        nsp.setBankAccount(sp.getBankAccount());
        nsp.setCollaborator(collaboratorService.findById(clb_id));
        repo.save(nsp);
        if(sp.getSTP_ID()==null){
            jso.put("errorCode",0);
            jso.put("message","Thêm người thụ hưởng thành công!");

        }else{
            if(repo.findById(sp.getSTP_ID()).isPresent()){
                jso.put("errorCode",0);
                jso.put("message","Cập nhật người thụ hưởng thành công!");
            }else{
                jso.put("errorCode",1);
                jso.put("message","Cập nhật thất bại! Người thụ hưởng đã bị xoá trước đó!");
            }
        }
        return jso;
    }

    public JSONObject delete(Integer id, Integer clb_id) {
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            this.repo.deleteById(id);
            jso.put("errorCode",0);
            jso.put("message","Xoá người thụ hưởng thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("message","Người thụ hưởng đã bị xoá trước đó!");
        }
        return jso;
    }
}

package com.macia.chariBE.service;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.Donator;
import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.repository.ICollaboratorRepository;
import com.macia.chariBE.repository.IJwtUserRepository;
import com.macia.chariBE.utility.EUserStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class CollaboratorService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ICollaboratorRepository repo;

    @Autowired
    private IJwtUserRepository userRepository;

    public void save(Collaborator collaborator) {
        repo.saveAndFlush(collaborator);
    }

    public void deleteById(Integer id){
        Collaborator c = findById(id);
        JwtUser user = userRepository.findByUsername(c.getUsername());
        userRepository.delete(user);
        repo.deleteById(id);
    }

    public List<Collaborator> findAll(){
        TypedQuery<Collaborator> query = em.createNamedQuery("named.collaborator.findAll", Collaborator.class);
        return query.getResultList();
    }

    public int countAll() {
        TypedQuery<Collaborator> query = em.createNamedQuery("named.collaborator.findAll", Collaborator.class);
        return query.getResultList().size();
    }

    public List<Collaborator> getPerPageAndSize(int a,int b) {
        TypedQuery<Collaborator> query = em.createNamedQuery("named.collaborator.findAll", Collaborator.class)
                .setFirstResult(a*b).setMaxResults(b);
        return query.getResultList();
    }
    public Collaborator findByUsername(String usn) {
        try {
            return repo.findByUsername(usn);
        } catch (NoResultException e) {
            return null;
        }
    }

    public Collaborator findById(Integer clb_id) {
        try {
            return repo.findById(clb_id).orElseThrow();
        } catch (NoResultException e) {
            return null;
        }
    }
    public void accept(Integer id){
        Collaborator c = findById(id);
        c.setIsAccept(true);
        repo.saveAndFlush(c);
        JwtUser user = userRepository.findByUsername(c.getUsername());
        user.setStatus(EUserStatus.ACTIVATED);
        userRepository.save(user);
    }
    public void block(Integer id){
        Collaborator c = findById(id);
        c.setIsAccept(false);
        repo.saveAndFlush(c);
        JwtUser user = userRepository.findByUsername(c.getUsername());
        user.setStatus(EUserStatus.BLOCKED);
        userRepository.save(user);
    }
}

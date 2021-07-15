package com.macia.chariBE.service;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.repository.ICollaboratorRepository;
import com.macia.chariBE.repository.IJwtUserRepository;
import com.macia.chariBE.utility.EUserStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;
import java.util.List;

@Service
public class CollaboratorService {

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

    public List<Collaborator> findAll(){return repo.findAll();}

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
    public List<Collaborator> accept(Integer id){
        Collaborator c = findById(id);
        c.setIsAccept(true);
        repo.saveAndFlush(c);
        JwtUser user = userRepository.findByUsername(c.getUsername());
        user.setStatus(EUserStatus.ACTIVATED);
        userRepository.save(user);
        return findAll();
    }
    public List<Collaborator> block(Integer id){
        Collaborator c = findById(id);
        c.setIsAccept(false);
        repo.saveAndFlush(c);
        JwtUser user = userRepository.findByUsername(c.getUsername());
        user.setStatus(EUserStatus.BLOCKED);
        userRepository.save(user);
        return findAll();
    }
}

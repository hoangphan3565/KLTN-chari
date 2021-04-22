package com.macia.chariBE.service;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.repository.CollaboratorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;
import java.util.List;

@Service
public class CollaboratorService {

    @Autowired
    private CollaboratorRepository repo;

    public void save(Collaborator collaborator) {
        repo.saveAndFlush(collaborator);
    }

    public void deleteById(Integer id){ repo.deleteById(id);}

    public List<Collaborator> findAll(){return repo.findAll();}

    public Collaborator findByPhone(String phone) {
        try {
            return repo.findByPhoneNumber(phone);
        } catch (NoResultException e) {
            return null;
        }
    }

}

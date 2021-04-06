package com.macia.chariBE.service;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.repository.CollaboratorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;

@Service
public class CollaboratorService {

    @Autowired
    private CollaboratorRepository collaboratorRepo;

    public void save(Collaborator collaborator) {
        collaboratorRepo.saveAndFlush(collaborator);
    }

    public Collaborator findByPhone(String phone) {
        try {
            return collaboratorRepo.findByPhoneNumber(phone);
        } catch (NoResultException e) {
            return null;
        }
    }

}

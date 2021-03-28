package com.macia.charitysystem.service;

import com.macia.charitysystem.model.Collaborator;
import com.macia.charitysystem.model.Donator;
import com.macia.charitysystem.repository.CollaboratorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;
import java.util.List;

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

package com.macia.charitysystem.service;

import com.macia.charitysystem.model.Collaborator;
import com.macia.charitysystem.repository.CollaboratorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CollaboratorService {

    @Autowired
    private CollaboratorRepository collaboratorRepo;

    public void save(Collaborator collaborator) {
        collaboratorRepo.saveAndFlush(collaborator);
    }
}

package com.macia.charitysystem.repository;

import com.macia.charitysystem.model.Collaborator;
import com.macia.charitysystem.model.Donator;
import com.macia.charitysystem.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CollaboratorRepository extends JpaRepository<Collaborator, Integer> {
    Collaborator findByPhoneNumber(String phone);
}

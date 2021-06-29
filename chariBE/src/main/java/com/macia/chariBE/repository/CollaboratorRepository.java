package com.macia.chariBE.repository;

import com.macia.chariBE.model.Collaborator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CollaboratorRepository extends JpaRepository<Collaborator, Integer> {
    Collaborator findByUsername(String phone);
}

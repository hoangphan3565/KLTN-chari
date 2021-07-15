package com.macia.chariBE.repository;

import com.macia.chariBE.model.Donator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IDonatorRepository extends JpaRepository<Donator, Integer> {
    Donator findByUsername(String username);
}

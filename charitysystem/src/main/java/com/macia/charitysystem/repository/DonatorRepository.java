package com.macia.charitysystem.repository;

import com.macia.charitysystem.model.Donator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonatorRepository extends JpaRepository<Donator, Integer> {
    Donator findByPhoneNumber(String phone);
}

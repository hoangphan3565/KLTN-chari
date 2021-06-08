package com.macia.chariBE.repository;

import com.macia.chariBE.model.Donator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonatorRepository extends JpaRepository<Donator, Integer> {
    Donator findByPhoneNumber(String phone);
    Donator findByFacebookId(String facebookId);
}

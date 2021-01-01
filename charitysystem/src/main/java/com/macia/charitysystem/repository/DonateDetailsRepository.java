package com.macia.charitysystem.repository;

import com.macia.charitysystem.model.DonateActivity;
import com.macia.charitysystem.model.DonateDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonateDetailsRepository extends JpaRepository<DonateDetails, Integer> {
}

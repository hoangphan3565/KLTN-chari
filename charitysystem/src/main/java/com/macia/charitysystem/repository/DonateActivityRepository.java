package com.macia.charitysystem.repository;

import com.macia.charitysystem.model.Collaborator;
import com.macia.charitysystem.model.DonateActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonateActivityRepository extends JpaRepository<DonateActivity, Integer> {
}

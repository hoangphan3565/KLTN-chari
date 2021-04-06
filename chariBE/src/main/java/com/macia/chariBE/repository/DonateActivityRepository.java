package com.macia.chariBE.repository;

import com.macia.chariBE.model.DonateActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonateActivityRepository extends JpaRepository<DonateActivity, Integer> {
}

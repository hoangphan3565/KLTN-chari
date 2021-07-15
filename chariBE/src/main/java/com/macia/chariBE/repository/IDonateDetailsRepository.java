package com.macia.chariBE.repository;

import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.model.DonateDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface IDonateDetailsRepository extends JpaRepository<DonateDetails, Integer> {
}

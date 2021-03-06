package com.macia.chariBE.repository;

import com.macia.chariBE.model.SupportedPeople;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ISupportedPeopleRepository extends JpaRepository<SupportedPeople, Integer> {
}

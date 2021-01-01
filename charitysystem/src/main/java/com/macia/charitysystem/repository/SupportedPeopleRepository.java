package com.macia.charitysystem.repository;

import com.macia.charitysystem.model.SupportedPeople;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SupportedPeopleRepository extends JpaRepository<SupportedPeople, Integer> {
}

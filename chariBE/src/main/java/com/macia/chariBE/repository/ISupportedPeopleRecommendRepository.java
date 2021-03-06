package com.macia.chariBE.repository;

import com.macia.chariBE.model.SupportedPeopleRecommend;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ISupportedPeopleRecommendRepository extends JpaRepository<SupportedPeopleRecommend, Integer> {
}

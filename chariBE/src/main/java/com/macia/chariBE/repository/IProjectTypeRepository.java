package com.macia.chariBE.repository;

import com.macia.chariBE.model.ProjectType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IProjectTypeRepository extends JpaRepository<ProjectType, Integer> {
}

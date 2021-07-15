package com.macia.chariBE.repository;

import com.macia.chariBE.model.ProjectImages;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IProjectImagesRepository extends JpaRepository<ProjectImages, Integer> {
}

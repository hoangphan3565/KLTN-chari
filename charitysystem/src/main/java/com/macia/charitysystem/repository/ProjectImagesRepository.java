package com.macia.charitysystem.repository;

import com.macia.charitysystem.model.Donator;
import com.macia.charitysystem.model.ProjectImages;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProjectImagesRepository  extends JpaRepository<ProjectImages, Integer> {
}

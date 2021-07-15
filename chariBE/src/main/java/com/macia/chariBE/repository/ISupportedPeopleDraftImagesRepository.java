package com.macia.chariBE.repository;

import com.macia.chariBE.model.SupportedPeopleDraft;
import com.macia.chariBE.model.SupportedPeopleDraftImages;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ISupportedPeopleDraftImagesRepository extends JpaRepository<SupportedPeopleDraftImages, Integer> {
}

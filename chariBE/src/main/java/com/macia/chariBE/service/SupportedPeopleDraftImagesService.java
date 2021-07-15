package com.macia.chariBE.service;

import com.macia.chariBE.model.Project;
import com.macia.chariBE.model.SupportedPeopleDraft;
import com.macia.chariBE.model.SupportedPeopleDraftImages;
import com.macia.chariBE.repository.ISupportedPeopleDraftImagesRepository;
import com.macia.chariBE.repository.ISupportedPeopleDraftRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

@Service
public class SupportedPeopleDraftImagesService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private ISupportedPeopleDraftImagesRepository repo;

    public List<SupportedPeopleDraftImages> findSupportedPeopleDraftImagesByDraftId(Integer id) {
        TypedQuery<SupportedPeopleDraftImages> query = em.createNamedQuery("named.supportedPeopleDraftImages.findByDraftId", SupportedPeopleDraftImages.class);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<String> findListStringImage(Integer id) {
        List<SupportedPeopleDraftImages> SupportedPeopleDraftImages = findSupportedPeopleDraftImagesByDraftId(id);
        List<String> list = new ArrayList<>();
        for (var projectImage : SupportedPeopleDraftImages) {
            list.add(projectImage.getImageUrl());
        }
        return list;
    }

    public List<SupportedPeopleDraftImages> createList(SupportedPeopleDraft p, List<String> images) {
        List<SupportedPeopleDraftImages> ls = new ArrayList<>();
        if(images!=null){
            for(String s:images){
                ls.add(SupportedPeopleDraftImages.builder().supportedPeopleDraft(p).imageUrl(s).build());
            }
        }
        return ls;
    }
    public void updateList(SupportedPeopleDraft p, List<String> images) {
        repo.deleteInBatch(this.findSupportedPeopleDraftImagesByDraftId(p.getSPD_ID()));
        if(images!=null){
            for(String s:images){
                repo.saveAndFlush(SupportedPeopleDraftImages.builder().supportedPeopleDraft(p).imageUrl(s).build());
            }
        }
    }
}

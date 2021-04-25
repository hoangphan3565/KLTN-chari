package com.macia.chariBE.service;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.Donator;
import com.macia.chariBE.repository.DonatorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;
import java.util.List;

@Service
public class DonatorService {

    @Autowired
    private DonatorRepository donatorRepo;

    public void save(Donator donator) {
        donatorRepo.saveAndFlush(donator);
    }

    public Donator findById(Integer id) {
        return donatorRepo.findById(id).orElseThrow();
    }

    public List<Donator> findAll(){return donatorRepo.findAll();}


    public Donator findByPhone(String phone) {
        try {
            return donatorRepo.findByPhoneNumber(phone);
        } catch (NoResultException e) {
            return null;
        }
    }

    public void addProjectIdToFavoriteList(Integer projectId, Integer donatorid) {
        Donator donator = donatorRepo.findById(donatorid).orElseThrow();
        donator.setFavoriteProject(donator.getFavoriteProject() + projectId.toString() + " ");
        donatorRepo.saveAndFlush(donator);
    }

    public void removeProjectIdFromFavoriteList(Integer projectId, Integer donatorid) {
        Donator donator = donatorRepo.findById(donatorid).orElseThrow();
        String[] curFavoriteList = donator.getFavoriteProject().split(" "); // "1 2 10 11 " -> [1,2,10,11,]
        StringBuilder sb = new StringBuilder();
        for (String s : curFavoriteList) {
            if (!s.equals(projectId.toString())) sb.append(s).append(" ");
        }
        donator.setFavoriteProject(sb.toString());
        donatorRepo.saveAndFlush(donator);
    }
}

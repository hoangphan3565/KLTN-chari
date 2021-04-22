package com.macia.chariBE.service;

import com.macia.chariBE.model.Feedback;
import com.macia.chariBE.repository.FeedbackRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.NoResultException;
import java.util.List;

@Service
public class FeedbackService {
    @Autowired
    private FeedbackRepository repo;

    public void save(Feedback Feedback) {
        repo.saveAndFlush(Feedback);
    }

    public void deleteById(Integer id){
        try {
            repo.deleteById(id);
        } catch (NoResultException e) {
            System.out.println(e);
        }
    }

    public List<Feedback> findAll(){return repo.findAll();}

}

package com.macia.chariBE.service;

import com.macia.chariBE.model.Post;
import com.macia.chariBE.model.PostImages;
import com.macia.chariBE.repository.PostImagesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

@Service
public class PostImagesService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private PostImagesRepository repo;

    public List<PostImages> findPostImagesByPostId(Integer id) {
        TypedQuery<PostImages> query = em.createNamedQuery("named.postImages.findByPostId", PostImages.class);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<String> findListPostImageStringByPostId(Integer id) {
        List<PostImages> postImages = findPostImagesByPostId(id);
        List<String> list = new ArrayList<>();
        for (var postImage : postImages) {
            list.add(postImage.getImageUrl());
        }
        return list;
    }



    public List<PostImages> createListPostImage(Post post,List<String> images) {
        List<PostImages> postImages = new ArrayList<>();
        if(images!=null){
            for(String s:images){
                postImages.add(PostImages.builder().post(post).imageUrl(s).build());
            }
        }
        return postImages;
    }
}

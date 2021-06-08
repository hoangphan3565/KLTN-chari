package com.macia.chariBE.service;

import com.macia.chariBE.DTO.PostDTO;
import com.macia.chariBE.model.Post;
import com.macia.chariBE.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

@Service
public class PostService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private PostRepository repo;

    @Autowired
    private PostImagesService postImagesService;

    public List<Post> findAll() {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findAll", Post.class);
        return query.getResultList();
    }

    public Post findById(Integer id) {
        try {
            TypedQuery<Post> query = em.createNamedQuery("named.post.findById", Post.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }


    public Post save(Post pt) {
        return repo.saveAndFlush(pt);
    }

    public void removeById(Integer id){
        repo.deleteById(id);
    }

    public List<PostDTO> getPostDTOs(){
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = repo.findAll();
        for(Post p : ps){
            r.add(PostDTO.builder()
                    .POS_ID(p.getPOS_ID()).name(p.getName()).content(p.getContent())
                    .imageUrl(p.getImageUrl()).videoUrl(p.getVideoUrl())
                    .images(this.postImagesService.findListPostImageStringByPostId(p.getPOS_ID()))
                    .createDate(p.getCreateDate()).updateDate(p.getUpdateDate())
                    .projectId(p.getProjectId()).isPublic(p.getIsPublic())
                    .build());
        }
        return r;
    }

    public List<PostDTO> savePost(PostDTO p){
        Post np = new Post();
        np.setPOS_ID(p.getPOS_ID());
        np.setName(p.getName());
        np.setContent(p.getContent());
        np.setIsPublic(p.getIsPublic());
        np.setProjectId(p.getProjectId());
        np.setImageUrl(p.getImageUrl());
        np.setVideoUrl(p.getVideoUrl());
        np.setPostImages(this.postImagesService.createListPostImage(np,p.getImages()));
        this.save(np);
        return this.getPostDTOs();
    }
}

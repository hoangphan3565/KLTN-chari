package com.macia.chariBE.service;

import com.macia.chariBE.DTO.PostDTO;
import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.Post;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.repository.PostRepository;
import org.apache.catalina.valves.rewrite.InternalRewriteMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PostService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private PostRepository repo;

    @Autowired
    private PostImagesService postImagesService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private CollaboratorService collaboratorService;

    public List<Post> findLikePostName(String name) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findLikePostName", Post.class);
        query.setParameter("name", "%" + name.toLowerCase() + "%");
        return query.getResultList();
    }

    public List<PostDTO> getPostDTOsLikePostName(String name){
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = this.findLikePostName(name);
        for(Post p : ps){
            Project project =  projectService.findProjectById(p.getProjectId());
            r.add(mapToDTO(p,project));
        }
        return r;
    }

    //== Services for Admin
    public Integer countAllPost() {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findAll", Post.class);
        return query.getResultList().size();
    }

    public List<Post> findPostsFromAToB(Integer a,Integer b) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findAll", Post.class)
                .setFirstResult(a)
                .setMaxResults(b-a);
        return query.getResultList();
    }
    public List<PostDTO> getPostDTOsFromAToB(Integer a,Integer b){
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = this.findPostsFromAToB(a,b);
        for(Post p : ps){
            Project project =  projectService.findProjectById(p.getProjectId());
            r.add(mapToDTO(p,project));
        }
        return r;
    }

    //== Services for Donators
    public Integer countAllPublicPost() {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findPublic", Post.class);
        return query.getResultList().size();
    }
    public List<Post> findPublicPostFromAToB(Integer a,Integer b) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findPublic", Post.class)
                .setFirstResult(a)
                .setMaxResults(b-a);
        return query.getResultList();
    }
    public List<PostDTO> getPublicPostDTOsFromAToB(Integer a,Integer b){
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = findPublicPostFromAToB(a,b);
        for(Post p : ps){
            Project project =  projectService.findProjectById(p.getProjectId());
            r.add(mapToDTO(p,project));
        }
        return r;
    }

    //== Services for Collaborators
    public Integer countAllPostByCollaboratorId(Integer id) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findPostByCollaboratorId", Post.class);
        query.setParameter("id", id);
        return query.getResultList().size();
    }
    public List<Post> findsPostByCollaboratorIdFromAToB(Integer id,Integer a,Integer b) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findPostByCollaboratorId", Post.class)
                .setFirstResult(a)
                .setMaxResults(b-a);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<PostDTO> getPostDTOsByCollaboratorIdFromAToB(Integer id,Integer a, Integer b) {
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = findsPostByCollaboratorIdFromAToB(id,a,b);
        for(Post p : ps){
            Project project =  projectService.findProjectById(p.getProjectId());
            r.add(mapToDTO(p,project));
        }
        return r;
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

    private PostDTO mapToDTO(Post p,Project prj){
        return PostDTO.builder()
                .POS_ID(p.getPOS_ID()).name(p.getName()).content(p.getContent())
                .imageUrl(p.getImageUrl()).videoUrl(p.getVideoUrl())
                .images(this.postImagesService.findListPostImageStringByPostId(p.getPOS_ID()))
                .publicTime(p.getPublicTime())
                .projectId(p.getProjectId()).projectName(prj.getProjectName())
                .collaboratorId(p.getCollaborator().getCLB_ID())
                .collaboratorName(p.getCollaborator().getFullName())
                .isPublic(p.getIsPublic()).build();
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
        np.setCollaborator(collaboratorService.findById(p.getCollaboratorId()));
        this.save(np);
        return this.getPostDTOsFromAToB(0,5);
    }
}

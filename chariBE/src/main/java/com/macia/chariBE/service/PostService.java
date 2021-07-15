package com.macia.chariBE.service;

import com.macia.chariBE.DTO.PostDTO;
import com.macia.chariBE.model.Post;
import com.macia.chariBE.model.Project;
import com.macia.chariBE.repository.IPostRepository;
import net.minidev.json.JSONObject;
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
    private IPostRepository repo;

    @Autowired
    private PostImagesService postImagesService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private CollaboratorService collaboratorService;


//    public List<PostDTO> getPostDTOsLikePostName(String name){
//        List<PostDTO> r = new ArrayList<>();
//        List<Post> ps = this.findLikePostName(name);
//        for(Post p : ps){
//            Project project =  projectService.findProjectById(p.getProjectId());
//            r.add(mapToDTO(p,project));
//        }
//        return r;
//    }

    //== Services for Admin
    public Integer countAllPost() {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findAll", Post.class);
        return query.getResultList().size();
    }

    public List<Post> findPostsPageASizeB(Integer a,Integer b) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findAll", Post.class)
                .setFirstResult(a*b).setMaxResults(b);
        return query.getResultList();
    }
    public List<PostDTO> getPostDTOsPageASizeB(Integer a,Integer b){
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = this.findPostsPageASizeB(a,b);
        for(Post p : ps){
            Project project =  projectService.findProjectById(p.getProjectId());
            r.add(mapToDTO(p,project));
        }
        return r;
    }

    //== Services for Donators
    public int countFoundPublicPost(String name) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findLikePostName", Post.class);
        if(name.equals("*")){
            query.setParameter("name", "%"+""+"%");
        }else{
            query.setParameter("name", "%" + name.toLowerCase() + "%");
        }
        return query.getResultList().size();
    }
    public List<Post> findLikePostName(String name,Integer a,Integer b) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findLikePostName", Post.class)
                .setFirstResult(a*b).setMaxResults(b);
        if(name.equals("*")){
            query.setParameter("name", "%"+""+"%");
        }else{
            query.setParameter("name", "%" + name.toLowerCase() + "%");
        }
        return query.getResultList();
    }
    public List<PostDTO> getPublicPostDTOsPageASizeBByName(String name,Integer a,Integer b){
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = findLikePostName(name,a,b);
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
    public List<Post> findsPostByCollaboratorIdPageASizeB(Integer id,Integer a,Integer b) {
        TypedQuery<Post> query = em.createNamedQuery("named.post.findPostByCollaboratorId", Post.class)
                .setFirstResult(a*b).setMaxResults(b);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<PostDTO> getPostDTOsByCollaboratorIdPageASizeB(Integer id,Integer a, Integer b) {
        List<PostDTO> r = new ArrayList<>();
        List<Post> ps = findsPostByCollaboratorIdPageASizeB(id,a,b);
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

    public JSONObject deleteById(Integer id,Integer clb_id){
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            this.repo.deleteById(id);
            jso.put("errorCode",0);
            jso.put("message","Xoá tin tức thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("message","Tin đã bị xoá trước đó!");
        }
        return jso;
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

    public JSONObject savePost(PostDTO p,Integer clb_id){
        JSONObject jso = new JSONObject();
        Post np = new Post();
        np.setPOS_ID(p.getPOS_ID());
        np.setName(p.getName());
        np.setContent(p.getContent());
        np.setIsPublic(p.getIsPublic());
        np.setProjectId(p.getProjectId());
        np.setImageUrl(p.getImageUrl());
        np.setVideoUrl(p.getVideoUrl());
        np.setPostImages(postImagesService.createListPostImage(np,p.getImages()));
        np.setCollaborator(collaboratorService.findById(p.getCollaboratorId()));
        this.save(np);
        if(p.getPOS_ID()==null){
            jso.put("errorCode",0);
            jso.put("message","Thêm tin thành công!");

        }else{
            if(repo.findById(p.getPOS_ID()).isPresent()){
                jso.put("errorCode",0);
                jso.put("message","Cập nhật tin thành công!");
            }else{
                jso.put("errorCode",1);
                jso.put("message","Cập nhật thất bại! Tin đã bị xoá trước đó!");
            }
        }
        return jso;
    }

    public JSONObject publicPost(Integer id, Integer clb_id) {
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            Post p = repo.findById(id).orElseThrow();
            p.setIsPublic(true);
            repo.saveAndFlush(p);
            jso.put("errorCode",0);
            jso.put("message","Hiện tin thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("message","Tin đã bị xoá trước đó!");
        }
        return jso;
    }

    public JSONObject unPublicPost(Integer id, Integer clb_id) {
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            Post p = repo.findById(id).orElseThrow();
            p.setIsPublic(false);
            repo.saveAndFlush(p);
            jso.put("errorCode",0);
            jso.put("message","Ẩn tin thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("message","Tin đã bị xoá trước đó!");
        }
        return jso;
    }
}

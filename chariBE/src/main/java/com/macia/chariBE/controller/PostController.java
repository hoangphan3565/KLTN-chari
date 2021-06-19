package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.PostDTO;
import com.macia.chariBE.model.Post;
import com.macia.chariBE.security.JwtResponse;
import com.macia.chariBE.service.PostService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/posts")
public class PostController {
    @Autowired
    PostService PostService;

    //Services for admin
    @GetMapping("/count")
    public ResponseEntity<?> countAllPost() {
        return ResponseEntity.ok().body(PostService.countAllPost());
    }
    @GetMapping("/from/{a}/to/{b}")
    public ResponseEntity<?> getPostsFromAToB(@PathVariable(value = "a") Integer a,
                                              @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(PostService.getPostDTOsFromAToB(a,b));
    }


    //Get posts of collaborator
    @GetMapping("/collaborator/{id}/count")
    public ResponseEntity<?> countPostByCollaboratorId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(PostService.countAllPostByCollaboratorId(id));
    }
    @GetMapping("/collaborator/{id}/from/{a}/to/{b}")
    public ResponseEntity<?> getAllPostByCollaboratorId(@PathVariable(value = "id") Integer id,
                                                        @PathVariable(value = "a") Integer a,
                                                        @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(PostService.getPostDTOsByCollaboratorIdFromAToB(id,a,b));
    }



    //Get những bài post đã được public
    @GetMapping("/public/count")
    public ResponseEntity<?> countPublicPost() {
        return ResponseEntity.ok().body(PostService.countAllPublicPost());
    }

    @GetMapping("/public/from/{a}/to/{b}")
    public ResponseEntity<?> getPublicPostFromAToB(@PathVariable(value = "a") Integer a,
                                                   @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(PostService.getPublicPostDTOsFromAToB(a,b));
    }


    @GetMapping("/{id}")
    public Post getPostById(@PathVariable(value = "id") Integer id) {
        return PostService.findById(id);
    }

    @PostMapping()
    public ResponseEntity<?> savePost(@RequestBody PostDTO p) {
        return ResponseEntity.ok().body(PostService.savePost(p));
    }

    @PutMapping("/public/{id}")
    public ResponseEntity<?> publicPost(@PathVariable(value = "id") Integer id) {
        Post p = PostService.findById(id);
        p.setIsPublic(true);
        PostService.save(p);
        return ResponseEntity.ok().body(PostService.getPostDTOsFromAToB(0,5));
    }

    @PutMapping("/un_public/{id}")
    public ResponseEntity<?> unPublicPost(@PathVariable(value = "id") Integer id) {
        Post p = PostService.findById(id);
        p.setIsPublic(false);
        PostService.save(p);
        return ResponseEntity.ok().body(PostService.getPostDTOsFromAToB(0,5));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> removePostById(@PathVariable(value = "id") Integer id) {
        PostService.removeById(id);
        return ResponseEntity.ok().body(PostService.getPostDTOsFromAToB(0,5));
    }
}

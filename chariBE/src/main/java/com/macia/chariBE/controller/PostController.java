package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.PostDTO;
import com.macia.chariBE.model.Post;
import com.macia.chariBE.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/posts")
public class PostController {
    @Autowired
    PostService PostService;

    @GetMapping()
    public ResponseEntity<?> getAllPost() {
        return ResponseEntity.ok().body(PostService.getPostDTOs());
    }

    @GetMapping("/{id}")
    public Post getPostById(@PathVariable(value = "id") Integer id) {
        return PostService.findById(id);
    }

    @PostMapping()
    public ResponseEntity<?> savePost(@RequestBody PostDTO p) {
        return ResponseEntity.ok().body(PostService.savePost(p));
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePost(@PathVariable(value = "id") Integer id, @RequestBody Post pt) {
        Post p = PostService.findById(id);
        p.setName(pt.getName());
        p.setContent(pt.getContent());
        p.setProjectId(pt.getProjectId());
        p.setIsPublic(pt.getIsPublic());
        p.setImageUrl(pt.getImageUrl());
        p.setVideoUrl(pt.getVideoUrl());
        PostService.save(p);
        return ResponseEntity.ok().body(PostService.getPostDTOs());
    }

    @PutMapping("/public/{id}")
    public ResponseEntity<?> publicPost(@PathVariable(value = "id") Integer id) {
        Post p = PostService.findById(id);
        p.setIsPublic(true);
        PostService.save(p);
        return ResponseEntity.ok().body(PostService.getPostDTOs());
    }

    @PutMapping("/un_public/{id}")
    public ResponseEntity<?> unPublicPost(@PathVariable(value = "id") Integer id) {
        Post p = PostService.findById(id);
        p.setIsPublic(false);
        PostService.save(p);
        return ResponseEntity.ok().body(PostService.getPostDTOs());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> removePostById(@PathVariable(value = "id") Integer id) {
        PostService.removeById(id);
        return ResponseEntity.ok().body(PostService.getPostDTOs());
    }
}

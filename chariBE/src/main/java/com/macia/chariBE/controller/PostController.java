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


    @GetMapping("/{id}")
    public ResponseEntity<?> getProjectByID(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(PostService.getPostDTOById(id));
    }


    //Services for admin
    @GetMapping("/count")
    public ResponseEntity<?> countAllPost() {
        return ResponseEntity.ok().body(PostService.countAllPost());
    }
    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getPostsPageASizeB(@PathVariable(value = "a") Integer a,
                                              @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(PostService.getPostDTOsPageASizeB(a-1,b));
    }


    //Get posts of collaborator
    @GetMapping("/collaborator/{id}/count")
    public ResponseEntity<?> countPostByCollaboratorId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(PostService.countAllPostByCollaboratorId(id));
    }
    @GetMapping("/collaborator/{id}/page/{a}/size/{b}")
    public ResponseEntity<?> getAllPostByCollaboratorId(@PathVariable(value = "id") Integer id,
                                                        @PathVariable(value = "a") Integer a,
                                                        @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(PostService.getPostDTOsByCollaboratorIdPageASizeB(id,a-1,b));
    }


    @GetMapping("/public/find/{name}/count")
    public ResponseEntity<?> countFoundPublicPost(@PathVariable(value = "name") String name) {
        return ResponseEntity.ok().body(PostService.countFoundPublicPost(name));
    }
    @GetMapping("/public/find/{name}/page/{a}/size/{b}")
    public ResponseEntity<?> findPostByName(@PathVariable(value = "name") String name,
                                            @PathVariable(value = "a") Integer a,
                                            @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(PostService.getPublicPostDTOsPageASizeBByName(name,a-1,b));
    }


    @PostMapping("/collaborator/{clb_id}")
    public ResponseEntity<?> savePost(@RequestBody PostDTO p,@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(PostService.savePost(p,clb_id));
    }

    @PutMapping("/public/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> publicPost(@PathVariable(value = "id") Integer id, @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(PostService.publicPost(id,clb_id));
    }

    @PutMapping("/un_public/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> unPublicPost(@PathVariable(value = "id") Integer id,  @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(PostService.unPublicPost(id,clb_id));
    }

    @DeleteMapping("/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> deletePostById(@PathVariable(value = "id") Integer id, @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(PostService.deleteById(id,clb_id));
    }
}

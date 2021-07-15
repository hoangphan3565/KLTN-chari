package com.macia.chariBE.controller;

import com.macia.chariBE.model.Comment;
import com.macia.chariBE.repository.ICommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/comments")
public class CommentController {
    @Autowired
    ICommentRepository repo;

    @GetMapping("/project/{id}")
    public ResponseEntity<?> getCommentByProjectId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(repo.findByProjectId(id).stream()
                .sorted(Comparator.comparing(Comment::getCommentDate).reversed())
                .collect(Collectors.toList()));
    }

    @PostMapping("/project/{id}")
    public ResponseEntity<?> saveComment(@PathVariable(value = "id") Integer id,@RequestBody Comment c) {
        repo.saveAndFlush(c);
        return ResponseEntity.ok().body(repo.findByProjectId(id).stream()
                .sorted(Comparator.comparing(Comment::getCommentDate).reversed())
                .collect(Collectors.toList()));
    }

    @DeleteMapping("/{id}/project/{pid}")
    public ResponseEntity<?> deleteComment(@PathVariable(value = "id") Integer id,@PathVariable(value = "id") Integer pid) {
        repo.deleteById(id);
        return ResponseEntity.ok().body(repo.findByProjectId(id).stream()
                .sorted(Comparator.comparing(Comment::getCommentDate).reversed())
                .collect(Collectors.toList()));
    }

}

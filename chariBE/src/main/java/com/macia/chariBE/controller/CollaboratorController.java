package com.macia.chariBE.controller;

import com.macia.chariBE.service.CollaboratorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
@RestController
@CrossOrigin("*")
@RequestMapping("/api/collaborators")
public class CollaboratorController {
    
    @Autowired
    CollaboratorService service;

    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(service.findAll());
    }

    @GetMapping("/count")
    public ResponseEntity<?> countAll() {
        return ResponseEntity.ok().body(service.countAll());
    }
    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getAll(@PathVariable(value = "a") Integer a,
                                    @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.getPerPageAndSize(a-1,b));
    }

    @PutMapping("/accept/{id}")
    public ResponseEntity<?> acceptCollaborator(@PathVariable(value = "id") Integer id) {
        service.accept(id);
        return ResponseEntity.ok().body("Phê duyệt thành công");
    }
    @PutMapping("/block/{id}")
    public ResponseEntity<?> blockCollaborator(@PathVariable(value = "id") Integer id) {
        service.block(id);
        return ResponseEntity.ok().body("Block thành công");
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeCollaboratorById(@PathVariable(value = "id") Integer id) {
        service.deleteById(id);
        return ResponseEntity.ok().body(service.findAll());
    }
}
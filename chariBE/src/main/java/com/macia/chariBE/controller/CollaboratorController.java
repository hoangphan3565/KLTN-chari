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

    @PutMapping("/accept/{id}")
    public ResponseEntity<?> acceptCollaborator(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.accept(id));
    }
    @PutMapping("/block/{id}")
    public ResponseEntity<?> blockCollaborator(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.block(id));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeCollaboratorById(@PathVariable(value = "id") Integer id) {
        service.deleteById(id);
        return ResponseEntity.ok().body(service.findAll());
    }
}
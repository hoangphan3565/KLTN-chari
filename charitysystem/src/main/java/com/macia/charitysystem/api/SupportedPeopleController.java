package com.macia.charitysystem.api;

import com.macia.charitysystem.model.SupportedPeople;
import com.macia.charitysystem.repository.SupportedPeopleRepository;
import com.macia.charitysystem.service.SupportedPeopleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/supported_peoples")
public class SupportedPeopleController {
    @Autowired
    SupportedPeopleService service;

    @Autowired
    SupportedPeopleRepository repo;

    @GetMapping()
    public ResponseEntity<?> getAllSupportedPeople() {
        return ResponseEntity.ok().body(repo.findAll());
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> getSupportedPeopleById(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(repo.findById(id));
    }
    @PostMapping()
    public ResponseEntity<?> saveSupportedPeople(@RequestBody SupportedPeople SupportedPeople) {
        return ResponseEntity.ok().body(repo.saveAndFlush(SupportedPeople));
    }
    @DeleteMapping("/{id}")
    public void removeSupportedPeopleById(@PathVariable(value = "id") Integer id) {
        repo.deleteById(id);
    }
}

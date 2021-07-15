package com.macia.chariBE.controller;

import com.macia.chariBE.repository.ICityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/cities")
public class CityController {
    @Autowired
    ICityRepository repo;
    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(repo.findAll());
    }
}

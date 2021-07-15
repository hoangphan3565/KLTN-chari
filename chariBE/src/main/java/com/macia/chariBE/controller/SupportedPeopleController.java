package com.macia.chariBE.controller;

import com.macia.chariBE.model.SupportedPeople;
import com.macia.chariBE.repository.ISupportedPeopleRepository;
import com.macia.chariBE.service.SupportedPeopleService;
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
    ISupportedPeopleRepository repo;

    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(repo.findAll());
    }
    @GetMapping("/count")
    public ResponseEntity<?> countAll() {
        return ResponseEntity.ok().body(service.countAll());
    }
    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getAllSupportedPeople(@PathVariable(value = "a") Integer a,
                                                   @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.findAllPageAToB(a-1,b));
    }


    @GetMapping("/collaborator/{clb_id}")
    public ResponseEntity<?> getAllByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(service.findAllByCollaboratorId(clb_id));
    }

    @GetMapping("/collaborator/{clb_id}/count")
    public ResponseEntity<?> countByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(service.countByCollaboratorId(clb_id));
    }
    @GetMapping("/collaborator/{clb_id}/page/{a}/size/{b}")
    public ResponseEntity<?> getAllSupportedPeopleByCollaboratorId(@PathVariable(value = "clb_id") Integer id,
                                                                   @PathVariable(value = "a") Integer a,
                                                                   @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.findByCollaboratorIdPageAToB(id,a-1,b));
    }

    @PostMapping("/collaborator/{clb_id}")
    public ResponseEntity<?> saveSupportedPeople(@RequestBody SupportedPeople sp,
                                                 @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(service.save(sp,clb_id));
    }
    @DeleteMapping("/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> removeSupportedPeopleById(@PathVariable(value = "id") Integer id,
                                                       @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(service.delete(id,clb_id));
    }
}

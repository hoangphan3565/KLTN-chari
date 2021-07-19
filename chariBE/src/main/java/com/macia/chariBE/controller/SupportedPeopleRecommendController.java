package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.SupportedPeopleDraftDTO;
import com.macia.chariBE.model.SupportedPeople;
import com.macia.chariBE.model.SupportedPeopleDraft;
import com.macia.chariBE.model.SupportedPeopleRecommend;

import com.macia.chariBE.repository.ISupportedPeopleRecommendRepository;
import com.macia.chariBE.service.SupportedPeopleRecommendService;
import com.macia.chariBE.service.SupportedPeopleService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/supported_people_recommends")
public class SupportedPeopleRecommendController {
    @Autowired
    SupportedPeopleRecommendService service;

    @Autowired
    ISupportedPeopleRecommendRepository repo;


    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(repo.findAll());
    }

    @GetMapping("/count")
    public ResponseEntity<?> countAll() {
        return ResponseEntity.ok().body(service.countAll());
    }


    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getAllSupportedPeople(@PathVariable(value = "a") Integer a, @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.findPageASizeB(a-1,b));
    }

    @GetMapping("/check/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> checkStatus(@PathVariable(value = "id") Integer id, @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(service.checkStatus(id,clb_id));
    }

    @PostMapping("/un_handle/{id}")
    public void unHandle(@PathVariable(value = "id") Integer id) {
        service.unHandle(id);
    }

    @PostMapping("/save_draft_step1")
    public ResponseEntity<?> saveDraft1(@RequestBody SupportedPeopleDraftDTO sp) {
        return ResponseEntity.ok().body(service.saveDraftStep1(sp));
    }

    @PostMapping("/save_draft_step2")
    public ResponseEntity<?> saveDraft2(@RequestBody SupportedPeopleDraftDTO sp) {
        return ResponseEntity.ok().body(service.saveDraftStep2(sp));
    }

    @PostMapping("/create_project")
    public ResponseEntity<?> createProject(@RequestBody SupportedPeopleDraftDTO sp) {

        return ResponseEntity.ok().body(service.createProject(sp));
    }

    @PostMapping()
    public ResponseEntity<?> saveSupportedPeople(@RequestBody SupportedPeopleRecommend sp) {
        JSONObject jso = new JSONObject();
        service.save(sp);
        jso.put("errorCode",0);
        jso.put("message","Gửi hoàn cảnh thành công! Chúng tôi sẽ liên hệ lại!");
        return ResponseEntity.ok().body(jso);
    }
}

package com.macia.chariBE.controller;

import com.macia.chariBE.model.Feedback;
import com.macia.chariBE.service.FeedbackService;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/feedbacks")
public class FeedbackController {
    @Autowired
    FeedbackService service;

    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(service.findAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeById(@PathVariable(value = "id") Integer id) {
        service.deleteById(id);
        return ResponseEntity.ok().body(service.findAll());
    }

    @PostMapping()
    public ResponseEntity<?> save(@RequestBody Feedback feedback) {
        service.save(feedback);
        JSONObject jo = new JSONObject();
        jo.put("errorCode", 0);
        jo.put("message", "Đóng góp ý kiến thành công!");
        jo.put("data", feedback);
        return ResponseEntity.ok(jo.toMap());
    }
}

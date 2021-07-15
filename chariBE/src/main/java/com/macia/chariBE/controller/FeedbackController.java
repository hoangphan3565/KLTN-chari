package com.macia.chariBE.controller;

import com.macia.chariBE.model.Feedback;
import com.macia.chariBE.service.FeedbackService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/feedbacks")
public class FeedbackController {
    @Autowired
    FeedbackService service;

    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getAll(@PathVariable(value = "a") Integer a,@PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.findPageASizeB(a-1,b));
    }

    @GetMapping("/count")
    public ResponseEntity<?> countAll() {
        return ResponseEntity.ok().body(service.countAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeById(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.deleteById(id));
    }

    @PostMapping()
    public ResponseEntity<?> save(@RequestBody Feedback feedback) {
        service.save(feedback);
        JSONObject jso = new JSONObject();
        jso.put("errorCode", 0);
        jso.put("message", "Đóng góp ý kiến thành công!");
        jso.put("data", feedback);
        return ResponseEntity.ok(jso);
    }

    @PostMapping("/reply")
    public ResponseEntity<?> replyFeedback(@RequestBody Feedback fk) {
        return ResponseEntity.ok().body(service.replyFeedback(fk));
    }
}

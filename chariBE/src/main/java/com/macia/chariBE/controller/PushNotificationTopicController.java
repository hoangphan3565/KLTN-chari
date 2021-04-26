package com.macia.chariBE.controller;

import com.macia.chariBE.model.PushNotificationTopic;
import com.macia.chariBE.repository.PushNotificationTopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/push_notification_topics")
public class PushNotificationTopicController {
    @Autowired
    PushNotificationTopicRepository repo;

    @GetMapping()
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok().body(repo.findAll());
    }

    @PostMapping()
    public ResponseEntity<?> savePushNotificationTopic(@RequestBody PushNotificationTopic topic) {
        repo.save(topic);
        return ResponseEntity.ok().body(repo.findAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> removePushNotificationTopicById(@PathVariable(value = "id") Integer id) {
        repo.deleteById(id);
        return ResponseEntity.ok().body(repo.findAll());
    }
}

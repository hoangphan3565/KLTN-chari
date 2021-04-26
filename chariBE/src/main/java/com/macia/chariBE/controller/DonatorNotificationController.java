package com.macia.chariBE.controller;

import com.macia.chariBE.model.DonatorNotification;
import com.macia.chariBE.service.DonatorNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/donator_notifications")
public class DonatorNotificationController {

    @Autowired
    DonatorNotificationService service;

    @PostMapping()
    public ResponseEntity<?> save(@RequestBody DonatorNotification notification) {
        service.save(notification);
        return ResponseEntity.ok().body(notification);
    }

    @GetMapping("/donator/{id}")
    public ResponseEntity<?> findByDonatorId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.findDonatorNotificationByDonatorId(id));
    }
}

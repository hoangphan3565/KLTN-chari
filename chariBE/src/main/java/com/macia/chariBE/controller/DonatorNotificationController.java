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

    @GetMapping("/donator/{id}")
    public ResponseEntity<?> findByDonatorId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.findDonatorNotificationByDonatorId(id));
    }

    @PutMapping("/handle_all")
    public ResponseEntity<?> handleAllCloseAndUnHandled() {
        service.handleAllMoneyOfClosedProjectOverSevenDay();
        return ResponseEntity.ok().body("Xử lý thành công");
    }

    @PutMapping("/read/donator/{id}")
    public ResponseEntity<?> putReadUnreadNotification(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.putReadUnreadNotification(id));
    }

    @GetMapping("/check_new/donator/{id}")
    public ResponseEntity<?> checkHaveNewNotification(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(service.checkHaveNewNotificationUnread(id));
    }

}

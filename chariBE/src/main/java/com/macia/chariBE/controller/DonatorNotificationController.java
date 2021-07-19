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


    @GetMapping("/donator/{dntid}/find/{skey}/count")
    public ResponseEntity<?> getTotalDonateDetailsOfDonatorByNotificationTitle(@PathVariable(value = "dntid") Integer id,
                                                                               @PathVariable(value = "skey") String skey) {
        return ResponseEntity.ok().body(service.countAllDonatorNotificationByDonatorIdAndTitle(id,skey));
    }

    @GetMapping("/donator/{dntid}/find/{skey}/page/{a}/size/{b}")
    public ResponseEntity<?> getDonateDetailsOfDonatorByNotificationTitle(@PathVariable(value = "dntid") Integer id, @PathVariable(value = "skey") String skey,
                                                                          @PathVariable(value = "a") Integer a, @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(service.findDonatorNotificationByDonatorIdAndTitlePageASizeB(id,skey,a-1,b));
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

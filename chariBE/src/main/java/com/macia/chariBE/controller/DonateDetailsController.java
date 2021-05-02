package com.macia.chariBE.controller;

import com.macia.chariBE.service.DonateDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/donate_details")
public class DonateDetailsController {
    @Autowired
    DonateDetailsService donateDetailsService;

    @GetMapping("donator/{dntid}")
    public ResponseEntity<?> getDonateDetailsOfDonatorByDonatorId(@PathVariable(value = "dntid") Integer id) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByDonatorId(id));
    }

    @GetMapping("project/{prjid}")
    public ResponseEntity<?> getDonateDetailsByProjectId(@PathVariable(value = "prjid") Integer id) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByProjectId(id));
    }
}

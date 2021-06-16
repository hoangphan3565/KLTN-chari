package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.DonateDetails.DonateDetailsWithBankDTO;
import com.macia.chariBE.model.Feedback;
import com.macia.chariBE.service.DonateDetailsService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/donate_details")
public class DonateDetailsController {
    @Autowired
    DonateDetailsService donateDetailsService;

    @GetMapping("/donator/{dntid}/count")
    public ResponseEntity<?> getTotalDonateDetailsOfDonator(@PathVariable(value = "dntid") Integer id) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByDonatorId(id).size());
    }

    @GetMapping("/donator/{dntid}/from/{a}/to/{b}")
    public ResponseEntity<?> getDonateDetailsOfDonatorByDonatorIdWithNumOfRecord(@PathVariable(value = "dntid") Integer id,
                                                                                 @PathVariable(value = "a") Integer a,
                                                                                 @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByDonatorIdFromAToB(id,a,b));
    }

    @GetMapping("/donator/{dntid}")
    public ResponseEntity<?> getDonateDetailsOfDonatorByDonatorId(@PathVariable(value = "dntid") Integer id) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByDonatorId(id));
    }

    @GetMapping("/project/{prjid}")
    public ResponseEntity<?> getDonateDetailsByProjectId(@PathVariable(value = "prjid") Integer id) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByProjectId(id));
    }

    @PostMapping("/donate_with_bank")
    public int saveDonateDetailsWithBank(@RequestBody List<DonateDetailsWithBankDTO> donations) {
        donateDetailsService.saveDonateDetailsWithBank(donations);
        donateDetailsService.disbursedProjectWithBank(donations);
        return 1;
    }
}

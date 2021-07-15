package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.DonateDetails.DonateDetailsWithBankDTO;
import com.macia.chariBE.model.Feedback;
import com.macia.chariBE.service.DonateDetailsService;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/donate_details")
public class DonateDetailsController {
    @Autowired
    DonateDetailsService donateDetailsService;

    @GetMapping("/donator/{dntid}/find/{name}/count")
    public ResponseEntity<?> getTotalDonateDetailsOfDonator(@PathVariable(value = "dntid") Integer id,@PathVariable(value = "name") String name) {
        return ResponseEntity.ok().body(donateDetailsService.countAllDonateDetailsByDonatorIdAndProjectName(id,name));
    }

    @GetMapping("/donator/{dntid}/find/{name}/page/{a}/size/{b}")
    public ResponseEntity<?> getDonateDetailsOfDonatorByDonatorIdWithNumOfRecord(@PathVariable(value = "dntid") Integer id, @PathVariable(value = "name") String name,
                                                                                 @PathVariable(value = "a") Integer a, @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(donateDetailsService.findDonateDetailsByDonatorIdAndProjectName(id,name,a-1,b));
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
        return 1;
    }

    @PostMapping("/disburse_with_bank")
    public ResponseEntity<?> disbursedProjectWithBank(@RequestBody List<DonateDetailsWithBankDTO> donations) {
        JSONObject jso = new JSONObject();
        int result = donateDetailsService.disbursedProjectWithBank(donations);
        if(result==0){
            jso.put("errorCode", 0);
            jso.put("message", "Cập nhật sao kê thành công!");
        }else{
            jso.put("errorCode", 1);
            jso.put("message", "Có trường hợp số tiền giải ngân không đúng, hãy kiểm tra lại!");
        }
        return new ResponseEntity<>(jso, HttpStatus.OK);
    }
}

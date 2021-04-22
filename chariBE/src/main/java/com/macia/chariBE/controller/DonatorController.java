package com.macia.chariBE.controller;

import com.macia.chariBE.model.Donator;
import com.macia.chariBE.repository.DonatorRepository;
import com.macia.chariBE.service.DonatorService;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/donators")
public class DonatorController {
    @Autowired
    DonatorService donatorService;

    @Autowired
    DonatorRepository donatorRepo;

    @GetMapping()
    public ResponseEntity<?> getAllDonator() {
        return ResponseEntity.ok().body(donatorRepo.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDonatorById(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(donatorService.findById(id));
    }

    @PostMapping()
    public ResponseEntity<?> saveDonator(@RequestBody Donator donator) {
        donatorService.save(donator);
        return ResponseEntity.ok().body(donatorRepo.findAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeDonatorById(@PathVariable(value = "id") Integer id) {
        donatorRepo.deleteById(id);
        return ResponseEntity.ok().body(donatorRepo.findAll());
    }

    @GetMapping("phone/{phone}")
    public ResponseEntity<?> getDonatorByPhone(@PathVariable(value = "phone") String phone) {
        return ResponseEntity.ok().body(donatorService.findByPhone(phone));
    }

    @PostMapping("/add_favorite/project/{prjid}/donator_id/{dntid}")
    public ResponseEntity<?> addProjectToFavoriteList(@PathVariable(value = "prjid") Integer prtid,
                                                      @PathVariable(value = "dntid") Integer dntid) {
        donatorService.addProjectIdToFavoriteList(prtid, dntid);
        return ResponseEntity.ok(donatorService.findById(dntid));
    }

    @PostMapping("/remove_favorite/project/{prjid}/donator_id/{dntid}")
    public ResponseEntity<?> removeProjectFromFavoriteList(@PathVariable(value = "prjid") Integer prtid,
                                                           @PathVariable(value = "dntid") Integer dntid) {
        donatorService.removeProjectIdFromFavoriteList(prtid, dntid);
        return ResponseEntity.ok(donatorService.findById(dntid));
    }
    @PostMapping("/update/id/{id}")
    public ResponseEntity<?> updateDonatorDetails(@PathVariable(value = "id") Integer id,@RequestBody Donator donator)    {
        JSONObject jo = new JSONObject();
        Donator dnt = donatorService.findById(id);
        if(dnt!=null)
        {
            dnt.setAddress(donator.getAddress());
            dnt.setFullName(donator.getFullName());
            donatorService.save(dnt);
            jo.put("errorCode", "0");
            jo.put("data", dnt);
            jo.put("message", "Cập nhật thông tin thành công!");
            return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
        }
        else{
            jo.put("errorCode", "1");
            jo.put("data", "");
            jo.put("message", "Cập nhật thông tin thất bại!");
            return new ResponseEntity<>(jo.toMap(), HttpStatus.BAD_REQUEST);
        }

    }


}

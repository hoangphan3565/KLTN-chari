package com.macia.chariBE.controller;

import com.macia.chariBE.model.Donator;
import com.macia.chariBE.repository.IDonatorRepository;
import com.macia.chariBE.service.DonatorNotificationService;
import com.macia.chariBE.service.DonatorService;
import net.minidev.json.JSONObject;
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
    IDonatorRepository donatorRepo;

    @Autowired
    DonatorNotificationService donatorNotificationService;

    @GetMapping()
    public ResponseEntity<?> getAllDonator() {
        return ResponseEntity.ok().body(donatorRepo.findAll());
    }

    @GetMapping("/count")
    public ResponseEntity<?> countAll() {
        return ResponseEntity.ok().body(donatorService.countAll());
    }

    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getAll(@PathVariable(value = "a") Integer a,
                                    @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(donatorService.getPerPageAndSize(a-1,b));
    }


    @GetMapping("/favorite_notification_list/{id}")
    public ResponseEntity<?> getNotificationListByDonatorId(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(donatorService.getFavoriteNotificationOfDonator(id));
    }

    @GetMapping("/username/{usn}")
    public ResponseEntity<?> getDonatorByPhone(@PathVariable(value = "usn") String usn) {
        return ResponseEntity.ok().body(donatorService.findByUsername(usn));
    }


    @PostMapping("/add_favorite/project/{prjid}/donator/{dntid}")
    public ResponseEntity<?> addProjectToFavoriteList(@PathVariable(value = "prjid") Integer prtid,
                                                      @PathVariable(value = "dntid") Integer dntid) {
        donatorService.addProjectIdToFavoriteList(prtid, dntid);
        return ResponseEntity.ok(donatorService.findById(dntid));
    }

    @PostMapping("/remove_favorite/project/{prjid}/donator/{dntid}")
    public ResponseEntity<?> removeProjectFromFavoriteList(@PathVariable(value = "prjid") Integer prtid,
                                                           @PathVariable(value = "dntid") Integer dntid) {
        donatorService.removeProjectIdFromFavoriteList(prtid, dntid);
        return ResponseEntity.ok(donatorService.findById(dntid));
    }

    @PostMapping("/update/id/{id}")
    public ResponseEntity<?> updateDonatorDetails(@PathVariable(value = "id") Integer id,@RequestBody Donator donator)    {
        JSONObject jso = new JSONObject();
        Donator dnt = donatorService.findById(id);
        if(dnt!=null)
        {
            dnt.setAddress(donator.getAddress());
            dnt.setFullName(donator.getFullName());
            donatorService.save(dnt);
            jso.put("errorCode", "0");
            jso.put("data", dnt);
            jso.put("message", "Cập nhật thông tin thành công!");
            return new ResponseEntity<>(jso, HttpStatus.OK);
        }
        else{
            jso.put("errorCode", "1");
            jso.put("data", "");
            jso.put("message", "Cập nhật thông tin thất bại!");
            return new ResponseEntity<>(jso, HttpStatus.BAD_REQUEST);
        }

    }
    @PutMapping("/move_money/project/{prjid}/donator/{dntid}/to_project/{tarprjid}/money/{money}")
    public ResponseEntity<?> moveDonationOfProjectToGeneralFund(
            @PathVariable(value = "prjid") Integer prjid,
            @PathVariable(value = "dntid") Integer dntid,
            @PathVariable(value = "tarprjid") Integer tarprjid,
            @PathVariable(value = "money") Integer money)    {
        JSONObject jso = new JSONObject();
        donatorService.moveMoney(prjid,dntid,tarprjid,money);
        donatorNotificationService.handleCloseProjectNotification(prjid,dntid);
        jso.put("errorCode", 0);
        jso.put("message", "Chuyển tiền thành công!");
        return new ResponseEntity<>(jso, HttpStatus.OK);
    }

    @PutMapping("/change_state_notification_list/{dntid}/nof_id/{nof_id}/value/{value}")
    public ResponseEntity<?> changeStateFavoriteNotificationList(
            @PathVariable(value = "dntid") Integer dntid,
            @PathVariable(value = "nof_id") Integer nof_id,
            @PathVariable(value = "value") boolean value)    {
        donatorService.changeStateFavoriteNotificationList(dntid,nof_id,value);
        return ResponseEntity.ok().body(donatorService.findById(dntid).getFavoriteNotification());
    }
}

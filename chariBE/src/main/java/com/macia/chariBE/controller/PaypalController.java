package com.macia.chariBE.controller;

import com.macia.chariBE.model.DonateActivity;
import com.macia.chariBE.model.DonateDetails;
import com.macia.chariBE.model.Order;
import com.macia.chariBE.repository.DonateDetailsRepository;
import com.macia.chariBE.service.*;
import com.macia.chariBE.utility.MoneyUtility;
import com.paypal.api.payments.Links;
import com.paypal.api.payments.Payment;
import com.paypal.base.rest.PayPalRESTException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;


@RestController
@CrossOrigin("*")
@RequestMapping("/api/paypal")
public class PaypalController {

    @Value("${server.address}")
    private String server_address;

    @Value("${server.port}")
    private String server_port;

    @Autowired
    PaypalService service;

    @Autowired
    DonateActivityService donateActivityService;

    @Autowired
    DonatorService donatorService;

    @Autowired
    ProjectService projectService;

    @Autowired
    DonateDetailsService donateDetailsService;

    @Autowired
    DonateDetailsRepository donateDetailsRepository;


    @GetMapping()
    public String home() {
        return "paypal home";
    }

    String messge;

    @Transactional
    @PostMapping("/donator_id/{did}/project_id/{pid}/donate")
    public String payment(@PathVariable(value = "did") Integer donator_id,
                          @PathVariable(value = "pid") Integer project_id,
                          @RequestBody Order order) {
        int price = (int)order.getPrice();
        this.messge=order.getDescription();
        order.setPrice(MoneyUtility.VNDToUSD(order.getPrice()));
        order.setCurrency("USD");
        order.setMethod("PAYPAL");
        order.setIntent("sale"); //sale-thanh toán ngay | authorize-bên đặt mất tiền nhưng bên bán chưa có tiền | order-tạo đơn đặt hàng, cả 2 bên đều chưa có tiền
        try {
            Payment payment = service.createPayment(
                    order.getPrice(),
                    order.getCurrency(),
                    order.getMethod(),
                    order.getIntent(),
                    order.getDescription(),
                    "http://" + server_address + ":"+server_port+"/api/paypal/cancel",
                    "http://" + server_address + ":"+server_port+"/api/paypal/success/donator_id/" + donator_id + "/project_id/" + project_id + "/money/" + price);
            for (Links link : payment.getLinks()) {
                if (link.getRel().equals("approval_url")) {
                    return link.getHref();
                }
            }
        } catch (PayPalRESTException e) {
            e.printStackTrace();
        }
        return "error";
    }


    @Transactional
    @GetMapping("/success/donator_id/{did}/project_id/{pid}/money/{money}")
    public ResponseEntity<?> successPay(
            @PathVariable(value = "did") Integer donator_id,
            @PathVariable(value = "pid") Integer project_id,
            @PathVariable(value = "money") int money,
            @RequestParam("paymentId") String paymentId,
            @RequestParam("PayerID") String payerId) {
        JSONObject jo = new JSONObject();
        try {
            Payment payment = service.executePayment(paymentId, payerId);
            if (payment.getState().equals("approved")) {
                if(!checkValid(donator_id,project_id,money)){
                    jo.put("errorCode", "0");
                    jo.put("message", "Donate success!");
                    return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);

                }else{
                    this.handleSuccessPayment(donator_id,project_id,money);
                    jo.put("errorCode", "0");
                    jo.put("message", "Donate success!");
                    return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
                }
            }
        } catch (PayPalRESTException e) {
            System.out.println(e.getMessage());
        }
        jo.put("errorCode", "1");
        jo.put("message", "Donate fail!");
        return new ResponseEntity<>(jo.toMap(), HttpStatus.OK);
    }
    public boolean checkValid(Integer donator_id,Integer project_id,int money)
    {
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, project_id);
        List<DonateDetails> ls = donateDetailsService.findDonateDetailByDonateActivityId(donateActivity.getDNA_ID());
        DonateDetails temp = ls.get(ls.size()-1);int temp_minute = temp.getDonateDate().getMinute();
        int temp_hour = temp.getDonateDate().getHour();
        int temp_date = temp.getDonateDate().getDayOfYear();
        LocalDateTime now = LocalDateTime.now();
        return temp.getMoney() != money || temp_date != now.getDayOfYear() || temp_hour != now.getHour() || (temp_minute != now.getMinute() && temp_minute != now.getMinute() - 1);
    }

    public void handleSuccessPayment(Integer donator_id, Integer project_id, int money){
        DonateActivity donateActivity = donateActivityService.findDonateActivityByDonatorIdAndProjectID(donator_id, project_id);
        if (donateActivity == null) {
            donateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivityService.save(DonateActivity.builder()
                            .donator(donatorService.findById(donator_id))
                            .project(projectService.findProjectById(project_id))
                            .build()))
                    .donateDate(LocalDateTime.now())
                    .money(money)
                    .message(this.messge)
                    .build());
        }
        else {
            donateDetailsRepository.save(DonateDetails.builder()
                    .donateActivity(donateActivity)
                    .donateDate(LocalDateTime.now())
                    .money(money)
                    .message(this.messge)
                    .build());
        }
    }
}
package com.macia.chariBE.controller;

import com.macia.chariBE.model.Order;
import com.macia.chariBE.repository.IDonateDetailsRepository;
import com.macia.chariBE.service.*;
import com.macia.chariBE.utility.MoneyUtility;
import com.paypal.api.payments.Links;
import com.paypal.api.payments.Payment;
import com.paypal.base.rest.PayPalRESTException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;
import java.time.LocalDateTime;


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
    IDonateDetailsRepository IDonateDetailsRepository;


    @GetMapping()
    public String home() {
        return "paypal home";
    }


    @Transactional
    @PostMapping("/donator_id/{did}/project_id/{pid}/donate")
    public String payment(@PathVariable(value = "did") Integer donator_id,
                          @PathVariable(value = "pid") Integer project_id,
                          @RequestBody Order order) {
        int price = (int)order.getPrice();
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
    public String successPay(
            @PathVariable(value = "did") Integer donator_id,
            @PathVariable(value = "pid") Integer project_id,
            @PathVariable(value = "money") int money,
            @RequestParam("paymentId") String paymentId,
            @RequestParam("PayerID") String payerId) {
        try {
            Payment payment = service.executePayment(paymentId, payerId);
            if (payment.getState().equals("approved")) {
                donateDetailsService.saveDonateDetails(donator_id,project_id,money,LocalDateTime.now());
                return "Ủng hộ thành công";
            }
        } catch (PayPalRESTException e) {
            System.out.println(e.getMessage());
        }
        return "Ủng hộ thất bại";
    }
}
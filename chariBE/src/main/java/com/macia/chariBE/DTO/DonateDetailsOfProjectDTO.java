package com.macia.chariBE.DTO;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonateDetailsOfProjectDTO {
    private int money;
    private LocalDateTime donate_date;
    private String donator_name;
    private String phone;
    private String message;
}

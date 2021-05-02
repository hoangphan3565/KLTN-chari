package com.macia.chariBE.DTO;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonateDetailsTopDTO {
    private int money;
    private String donator_name;
    private String phone;
}

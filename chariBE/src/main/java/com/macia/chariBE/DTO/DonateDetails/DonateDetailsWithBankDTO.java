package com.macia.chariBE.DTO.DonateDetails;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonateDetailsWithBankDTO {
    private String amount;
    private String date;
    private String details;
}

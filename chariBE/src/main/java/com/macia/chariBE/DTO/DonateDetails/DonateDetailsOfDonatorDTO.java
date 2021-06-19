package com.macia.chariBE.DTO.DonateDetails;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonateDetailsOfDonatorDTO {
    private int money;
    private LocalDateTime donate_date;
    private Integer project_id;
    private String project_name;
    private String project_image;
    private String status;
}

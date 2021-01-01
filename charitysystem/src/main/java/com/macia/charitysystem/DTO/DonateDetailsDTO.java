package com.macia.charitysystem.DTO;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonateDetailsDTO {
    private Double money;
    private LocalDateTime donate_date;
    private Integer project_id;
    private String project_name;
}

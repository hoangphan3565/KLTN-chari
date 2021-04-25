package com.macia.chariBE.DTO;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonatorNotificationDTO {
    private String title;
    private String message;
    private LocalDateTime date_time;
    private Integer project_id;
}

package com.macia.chariBE.DTO;

import com.macia.chariBE.model.City;
import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.model.SupportedPeople;
import lombok.*;

import javax.persistence.Column;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SupportedPeopleDraftDTO {
    private Integer SPD_ID;
    private Integer sprID;

    private String referrerName;
    private String referrerPhone;
    private String referrerDescription;

    private String fullName;
    private String address;
    private String phoneNumber;
    private String bankName;
    private String bankAccount;

    private String projectCode;
    private String projectName;
    private String briefDescription;
    private String description;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer targetMoney;
    private String imageUrl;
    private String videoUrl;
    private Integer cti_ID;
    private City city;
    private Integer prt_ID;
    private ProjectType projectType;
    private List<String> images;
    private Boolean canDisburseWhenOverdue;
    private Integer clb_ID;
    private Collaborator collaborator;
}

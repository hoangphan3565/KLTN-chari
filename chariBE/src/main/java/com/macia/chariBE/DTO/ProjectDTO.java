package com.macia.chariBE.DTO;

import com.macia.chariBE.model.*;
import com.macia.chariBE.utility.EProjectStatus;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProjectDTO {
    private Integer PRJ_ID;
    private String projectCode;
    private String projectName;
    private String briefDescription;
    private String description;
    private String startDate;
    private String endDate;
    private Integer targetMoney;
    private String imageUrl;
    private String videoUrl;
    private Boolean verified;
    private Boolean disbursed;
    private Boolean closed;
    private LocalDateTime updateTime;
    private Integer cti_ID;
    private City city;
    private Integer prt_ID;
    private ProjectType projectType;
    private Integer stp_ID;
    private SupportedPeople supportedPeople;
    private Integer clb_ID;
    private Collaborator collaborator;

    private EProjectStatus status;
    private Integer curMoney;
    private double achieved;
    private Integer numOfDonations;
    private Long remainingTerm;
    private List<String> images;
    private double moveMoneyProgress;
}

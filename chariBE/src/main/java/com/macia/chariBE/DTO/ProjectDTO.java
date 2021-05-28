package com.macia.chariBE.DTO;

import com.macia.chariBE.model.Collaborator;
import com.macia.chariBE.model.ProjectType;
import com.macia.chariBE.model.SupportedPeople;
import lombok.*;

import java.util.List;

@Data
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
    private String imageUrl;
    private List<String> images;
    private String videoUrl;
    private Integer curMoney;
    private Integer targetMoney;
    private Integer numOfDonations;
    private String startDate;
    private String endDate;
    private Integer remainingTerm;
    private Boolean verified;
    private String status;
    private Boolean disbursed;
    private Boolean closed;
    private Integer prt_ID;
    private ProjectType projectType;
    private Integer stp_ID;
    private SupportedPeople supportedPeople;
    private Integer clb_ID;
    private Collaborator collaborator;
    private float priorityPoint;
}

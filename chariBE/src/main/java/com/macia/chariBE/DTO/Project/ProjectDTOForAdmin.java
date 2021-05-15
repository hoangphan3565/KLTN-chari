package com.macia.chariBE.DTO.Project;

import lombok.*;

import java.util.List;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProjectDTOForAdmin {
    private Integer PRJ_ID;
    private String projectName;
    private String briefDescription;
    private String description;
    private String videoUrl;
    private String imageUrl;
    private String startDate;
    private String endDate;
    private Integer targetMoney;
    private Integer prt_ID;
    private Integer stp_ID;
    private List<String> images;
}
package com.macia.chariBE.DTO.Project;

import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProjectReached {
    private Integer PRJ_ID;
    private String projectName;
    private Integer prt_ID;
    private Integer targetMoney;
    private Integer numOfPost;
    private Integer isDisbursement;

}

package com.macia.chariBE.DTO;

import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProjectDTOForAdmin {
    private Integer prj_id;
    private String project_name;
    private String brief_description;
    private String description;
    private String image_url;
    private String video_url;
    private String startDate;
    private String endDate;
    private Integer target_money;
    private Integer prt_ID;
    private Integer stp_ID;
    private List<String> images;
}
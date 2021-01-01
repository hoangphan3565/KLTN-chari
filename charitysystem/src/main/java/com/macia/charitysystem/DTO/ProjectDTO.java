package com.macia.charitysystem.DTO;

import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProjectDTO {
    private Integer prj_id;
    private String project_code;
    private String project_name;
    private String brief_description;
    private String description;
    private String image_url;
    private String video_url;
    private Integer target_money;
    private Integer cur_money;
    private Integer num_of_donations;
    private Integer remaining_term;
    private Integer prt_id;
    private String project_type_name;
    private String status;
}

package com.macia.chariBE.DTO;


import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PostDTO {
    private Integer POS_ID;
    private String name;
    private String content;
    private Integer projectId;
    private String projectName;
    private Boolean isPublic;
    private LocalDateTime publicTime;
    private String imageUrl;
    private String videoUrl;
    private Integer collaboratorId;
    private String collaboratorName;
    private List<String> images;
}

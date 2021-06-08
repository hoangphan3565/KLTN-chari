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
public class PostDTO {
    private Integer POS_ID;
    private String name;
    private String content;
    private Integer projectId;
    private Boolean isPublic;
    private LocalDate createDate;
    private LocalDate updateDate;
    private String imageUrl;
    private String videoUrl;
    private List<String> images;
}

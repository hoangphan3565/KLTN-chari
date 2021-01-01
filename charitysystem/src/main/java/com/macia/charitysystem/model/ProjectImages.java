package com.macia.charitysystem.model;

import com.macia.charitysystem.DTO.ImageDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@SuppressWarnings("ALL")
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.projectImages.findByProjectId",
                query = "SELECT NEW com.macia.charitysystem.DTO.ImageDTO(p.imageUrl) FROM ProjectImages p where p.project.PRJ_ID =:id"),
})
@SqlResultSetMappings({
        @SqlResultSetMapping(
                name = "ImageMapping",
                classes = @ConstructorResult(targetClass = ImageDTO.class,
                        columns = {
                                @ColumnResult(name = "imageUrl", type = String.class),
                        })
        ),
})
public class ProjectImages {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer PRI_ID;

    @Column(length = 500)
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "prj_id")
    private Project project;
}

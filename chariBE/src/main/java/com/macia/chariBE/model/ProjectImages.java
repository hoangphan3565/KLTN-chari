package com.macia.chariBE.model;

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
                query = "SELECT p FROM ProjectImages p where p.project.PRJ_ID =:id"),
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

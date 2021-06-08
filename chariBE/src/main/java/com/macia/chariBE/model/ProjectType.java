package com.macia.chariBE.model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.projectType.findAll",
                query = "SELECT p FROM ProjectType p"),
        @NamedQuery(name = "named.projectType.findById",
                query = "SELECT p FROM ProjectType p where p.PRT_ID =:id"),
})
public class ProjectType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer PRT_ID;

    @Column(length = 50)
    private String projectTypeName;

    @Column(length = 500)
    private String description;

    @Column(length = 300)
    private String imageUrl;

    @Column()
    private Boolean canDisburseWhenOverdue;

    @JsonIgnore
    @OneToMany(mappedBy = "projectType")
    private List<Project> projects;
}

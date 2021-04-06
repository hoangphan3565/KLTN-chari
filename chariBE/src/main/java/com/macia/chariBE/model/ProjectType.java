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
        @NamedQuery(name = "named.projecttype.findAll",
                query = "SELECT p FROM ProjectType p"),
        @NamedQuery(name = "named.projecttype.findById",
                query = "SELECT p FROM ProjectType p where p.PRT_ID =:id"),
})
public class ProjectType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer PRT_ID;

    @Column(unique = true, length = 10)
    private String ProjectTypeCode;

    @Column(length = 50)
    private String ProjectTypeName;

//    cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY,
    @JsonIgnore
    @OneToMany(mappedBy = "projectType")
    private List<Project> projects;
}

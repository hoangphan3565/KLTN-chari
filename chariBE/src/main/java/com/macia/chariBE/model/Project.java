package com.macia.chariBE.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@SuppressWarnings("ALL")
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.project.findById",
                query = "SELECT p FROM Project p where p.PRJ_ID =:id"),
        @NamedQuery(name = "named.project.findByProjectTypeId",
                query = "SELECT p FROM Project p where p.projectType.PRT_ID =:id"),
})
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer PRJ_ID;

    @Column(length = 10)
    private String projectCode;

    @Column(length = 300)
    private String projectName;

    @Column(length = 500)
    private String briefDescription;

    @Column(length = 4000)
    private String description;

    @Column
    private LocalDate startDate;

    @Column
    private LocalDate endDate;

    @Column
    private Integer targetMoney;

    @Column(length = 500)
    private String videoUrl;

    @Column(length = 500)
    private String imageUrl;

    @Column
    private Boolean verified;

    @Column
    private Boolean disbursed;

    @Column
    private Boolean closed;

    @ManyToOne
    @JoinColumn(name = "prt_id")
    private ProjectType projectType;

    @ManyToOne
    @JoinColumn(name = "stp_id")
    private SupportedPeople supportedPeople;

    @ManyToOne
    @JoinColumn(name = "clb_id")
    private Collaborator collaborator;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE},fetch = FetchType.EAGER, mappedBy = "project",orphanRemoval = true)
    private List<ProjectImages> projectImages;

    @JsonIgnore
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "project")
    private List<DonateActivity> donateActivities;
}

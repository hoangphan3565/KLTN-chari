package com.macia.chariBE.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.macia.chariBE.utility.EProcessingStatus;
import com.macia.chariBE.utility.EProjectStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@SuppressWarnings("ALL")
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.project.findAll",
                query = "SELECT p FROM Project p ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findById",
                query = "SELECT p FROM Project p where p.PRJ_ID =:id"),

        @NamedQuery(name = "named.project.findUncloseAndVerifiedByName",
                query = "SELECT p FROM Project p where p.closed=false and p.verified=true and lower(p.projectName) like :name ORDER BY p.updateTime desc"),
        @NamedQuery(name = "named.project.findUnVerified",
                query = "SELECT p FROM Project p where p.verified=false ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findClosed",
                query = "SELECT p FROM Project p where p.closed=true ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findActivating",
                query = "SELECT p FROM Project p where p.closed=false and p.verified=true and p.status=0 ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findReached",
                query = "SELECT p FROM Project p where p.closed=false and p.verified=true and p.status=1 ORDER BY p.disbursed asc"),
        @NamedQuery(name = "named.project.findOverdue",
                query = "SELECT p FROM Project p where p.closed=false and p.verified=true and p.status=2 ORDER BY p.projectType.canDisburseWhenOverdue asc"),


        @NamedQuery(name = "named.project.findUnVerifiedByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =: id and p.verified=false ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findVerifiedByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =: id and p.verified=true ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findUncloseByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =: id and p.closed=false ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findClosedByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =: id and p.closed=true ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findActivatingByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =:id and p.closed=false and p.verified=true and p.status=0 ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findReachedByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =:id and p.closed=false and p.verified=true and p.status=1 ORDER BY p.PRJ_ID desc"),
        @NamedQuery(name = "named.project.findOverdueByCollaboratorId",
                query = "SELECT p FROM Project p where p.collaborator.CLB_ID =:id and p.closed=false and p.verified=true and p.status=2 ORDER BY p.PRJ_ID desc"),


        //filter project on mobile short by updatetime
        @NamedQuery(name = "named.project.findFavoriteProject",
                query = "SELECT p FROM Project p where p.PRJ_ID in (:ids)"),
        @NamedQuery(name = "named.project.filterByProjectTypeIds",
                query = "SELECT p FROM Project p where p.projectType.PRT_ID in (:ptids)"),
        @NamedQuery(name = "named.project.filterByCityIds",
                query = "SELECT p FROM Project p where p.city.CTI_ID in (:ctids)"),

        //find project on mobile short by updatetime
        @NamedQuery(name = "named.project.findUncloseAndVerified",
                query = "SELECT p FROM Project p where p.closed=false and p.verified=true ORDER BY p.updateTime desc"),
        @NamedQuery(name = "named.project.findProjectMultiFilterAndSearchKey",
                query = "SELECT p FROM Project p " +
                        "where p.PRJ_ID in (:ids) and p.closed=false and p.verified=true and p.projectType.PRT_ID in (:ptids) and p.city.CTI_ID in (:cids) and p.status in (:status)" +
                        "and (lower(p.projectName) like :name or lower(p.briefDescription) like :name) " +
                        "ORDER BY p.status asc"),

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

    @Column()
    @Enumerated(EnumType.ORDINAL)
    private EProjectStatus status;

    @Column
    @UpdateTimestamp
    private LocalDateTime updateTime;

    @ManyToOne
    @JoinColumn(name = "cti_id")
    private City city;

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

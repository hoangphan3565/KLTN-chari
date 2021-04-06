package com.macia.chariBE.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.macia.chariBE.DTO.ProjectDTO;
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
})
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(
                name = "named_getProjectDTOList",
                resultSetMappings = "ProjectMapping",
                procedureName = "get_projects_dto"
        ),
})
@SqlResultSetMappings({
        @SqlResultSetMapping(
                name = "ProjectMapping",
                classes = @ConstructorResult(targetClass = ProjectDTO.class,
                        columns = {
                                @ColumnResult(name = "prj_id", type = Integer.class),
                                @ColumnResult(name = "project_code", type = String.class),
                                @ColumnResult(name = "project_name", type = String.class),
                                @ColumnResult(name = "brief_description", type = String.class),
                                @ColumnResult(name = "description", type = String.class),
                                @ColumnResult(name = "image_url", type = String.class),
                                @ColumnResult(name = "video_url", type = String.class),
                                @ColumnResult(name = "target_money", type = Integer.class),
                                @ColumnResult(name = "cur_money", type = Integer.class),
                                @ColumnResult(name = "num_of_donations", type = Integer.class),
                                @ColumnResult(name = "remaining_term", type = Integer.class),
                                @ColumnResult(name = "prt_id", type = Integer.class),
                                @ColumnResult(name = "project_type_name", type = String.class),
                                @ColumnResult(name = "status", type = String.class),

                        })
        ),
})
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer PRJ_ID;

    @Column(length = 10, unique = true)
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

    @Column(length = 20)
    private String status;

    @Column(length = 500)
    private String videoUrl;

    @Column(length = 500)
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "prt_id")
    private ProjectType projectType;

    @ManyToOne
    @JoinColumn(name = "stp_id")
    private SupportedPeople supportedPeople;

    @ManyToOne
    @JoinColumn(name = "clb_id")
    private Collaborator collaborator;

    //cascade = {CascadeType.PERSIST, CascadeType.MERGE},
    @JsonIgnore
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "project")
    private List<ProjectImages> projectImages;

    @JsonIgnore
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "project")
    private List<DonateActivity> donateActivities;
}

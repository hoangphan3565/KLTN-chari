package com.macia.chariBE.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SupportedPeopleDraft{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer SPD_ID;

    @Column(length = 50)
    private String referrerName;

    @Column(length = 10)
    private String referrerPhone;

    @Column(length = 1000)
    private String referrerDescription;

    @Column(length = 200)
    private String fullName;

    @Column(length = 200)
    private String address;

    @Column(length = 10)
    private String phoneNumber;

    @Column(length = 200)
    private String bankName;

    @Column(length = 50)
    private String bankAccount;

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

    @ManyToOne
    @JoinColumn(name ="cti_id")
    private City city;

    @ManyToOne
    @JoinColumn(name ="prt_id")
    private ProjectType projectType;

    @ManyToOne
    @JoinColumn(name = "clb_id")
    private Collaborator collaborator;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE},fetch = FetchType.EAGER, mappedBy = "supportedPeopleDraft",orphanRemoval = true)
    private List<SupportedPeopleDraftImages> draftImages;


    @Column()
    private Integer sprID;
}

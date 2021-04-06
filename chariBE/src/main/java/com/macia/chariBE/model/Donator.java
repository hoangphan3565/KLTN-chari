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
public class Donator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DNT_ID;

    @Column(length = 200)
    private String fullName;

    @Column(length = 200)
    private String address;

    @Column(length = 10)
    private String phoneNumber;

    @Column()
    private String avatarUrl;

    @Column
    private String favoriteProject;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "donator")
    private List<DonateActivity> donateActivities;
}

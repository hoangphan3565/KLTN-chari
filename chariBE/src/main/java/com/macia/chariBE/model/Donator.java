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

    @Column(length = 400)
    private String avatarUrl;

    @Column(length = 200)
    private String favoriteProject;

    @Column(length = 300)
    private String favoriteNotification;

    @Column(length = 50)
    private String facebookId;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "donator")
    private List<DonateActivity> donateActivities;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "donator")
    private List<DonatorNotification> userNotification;
}

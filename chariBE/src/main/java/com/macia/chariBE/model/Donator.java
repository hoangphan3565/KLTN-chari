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
        @NamedQuery(name = "named.donator.findAll",
                query = "SELECT d FROM Donator d order by d.DNT_ID desc"),
        @NamedQuery(name = "named.donator.findWhereHaveAccount",
                query = "SELECT d FROM Donator d where d.favoriteNotification is not null order by d.DNT_ID desc"),
        @NamedQuery(name = "named.donator.findById",
                query = "SELECT d FROM Donator d where d.DNT_ID =:id"),
})
public class Donator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DNT_ID;

    @Column(length = 200)
    private String fullName;

    @Column(length = 200)
    private String address;

    @Column(length = 20)
    private String phoneNumber;

    @Column(length = 400)
    private String avatarUrl;

    @Column(length = 200)
    private String favoriteProject;

    @Column(length = 300)
    private String favoriteNotification;

    @Column(length = 50)
    private String username;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "donator")
    private List<DonateActivity> donateActivities;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "donator")
    private List<DonatorNotification> userNotification;
}

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
        @NamedQuery(name = "named.collaborator.findAll",
                query = "SELECT d FROM Collaborator d order by d.CLB_ID desc"),
})
public class Collaborator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer CLB_ID;

    @Column(length = 100)
    private String fullName;

    @Column(length = 200)
    private String address;

    @Column(length = 20)
    private String username;

    @Column(length = 100)
    private String email;

    @Column(length = 10)
    private String phoneNumber;

    @Column(length = 500)
    private String certificate;

    @Column
    private Boolean isAccept;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, mappedBy = "collaborator")
    private List<Project> projects;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "collaborator",orphanRemoval = true)
    private List<Post> posts;
}

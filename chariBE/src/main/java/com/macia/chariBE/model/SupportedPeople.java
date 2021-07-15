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
        @NamedQuery(name = "named.supportedPeople.findAll",
                query = "SELECT s FROM SupportedPeople s order by s.STP_ID desc"),
        @NamedQuery(name = "named.supportedPeople.findById",
                query = "SELECT s FROM SupportedPeople s where s.STP_ID =:id"),
        @NamedQuery(name = "named.supportedPeople.findByCollaboratorId",
                query = "SELECT s FROM SupportedPeople s where s.collaborator.CLB_ID =:id order by s.STP_ID desc"),
})
public class SupportedPeople {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer STP_ID;

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

    @ManyToOne
    @JoinColumn(name = "clb_id")
    private Collaborator collaborator;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "supportedPeople")
    private List<Project> projects;
}

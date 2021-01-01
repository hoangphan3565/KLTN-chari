package com.macia.charitysystem.model;

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
        @NamedQuery(name = "named.supportedpeople.findAll",
                query = "SELECT s FROM SupportedPeople s"),
        @NamedQuery(name = "named.supportedpeople.findById",
                query = "SELECT s FROM SupportedPeople s where s.STP_ID =:id"),
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

    @Column(length = 50)
    private String bankAccount;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "supportedPeople")
    private List<Project> projects;
}

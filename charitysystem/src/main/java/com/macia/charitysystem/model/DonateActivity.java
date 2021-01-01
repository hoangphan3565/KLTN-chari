package com.macia.charitysystem.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@SuppressWarnings("ALL")
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.donate_activity.findByDonatorIdAndProjectId",
                query = "SELECT da FROM DonateActivity da where da.donator.DNT_ID =:did and da.project.PRJ_ID =:pid"),
})
public class DonateActivity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DNA_ID;

    @ManyToOne
    @JoinColumn(name = "dnt_id")
    private Donator donator;

    @ManyToOne
    @JoinColumn(name = "prj_id")
    private Project project;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY, mappedBy = "donateActivity")
    private List<DonateDetails> donateDetails;
}

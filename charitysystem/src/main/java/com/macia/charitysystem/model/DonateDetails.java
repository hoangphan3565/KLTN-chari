package com.macia.charitysystem.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@SuppressWarnings("ALL")
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.donate_details.findByDonatorId",
                query = "SELECT NEW com.macia.charitysystem.DTO.DonateDetailsDTO(dd.money,dd.donateDate,dd.donateActivity.project.PRJ_ID,dd.donateActivity.project.projectName) FROM DonateDetails dd where dd.donateActivity.donator.DNT_ID =:dntid order by dd.donateDate desc"),
})
public class DonateDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DND_ID;

    @Column
    private Double money;

    @Column
    private LocalDateTime donateDate;

    @ManyToOne
    @JoinColumn(name = "dna_id")
    private DonateActivity donateActivity;
}

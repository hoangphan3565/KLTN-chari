package com.macia.chariBE.model;

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
                query = "SELECT NEW com.macia.chariBE.DTO.DonateDetails.DonateDetailsOfDonatorDTO(dd.money,dd.donateDate,dd.donateActivity.project.PRJ_ID,dd.donateActivity.project.projectName,dd.donateActivity.status) FROM DonateDetails dd where dd.donateActivity.donator.DNT_ID =:dntid order by dd.donateDate desc"),
        @NamedQuery(name = "named.donate_details.findByProjectId",
                query = "SELECT NEW com.macia.chariBE.DTO.DonateDetails.DonateDetailsOfProjectDTO(dd.money,dd.donateDate,dd.donateActivity.donator.fullName,dd.donateActivity.donator.phoneNumber,dd.donateActivity.status) FROM DonateDetails dd where dd.donateActivity.project.PRJ_ID =:prjid order by dd.donateDate desc"),
        @NamedQuery(name = "named.donate_details.findByDonateActivityId",
                query = "SELECT dd FROM DonateDetails dd where dd.donateActivity.DNA_ID =: id"),
        @NamedQuery(name = "named.donate_details.findByDonateActivityIdAndDateTime",
                query = "SELECT dd FROM DonateDetails dd where dd.donateActivity.DNA_ID =: id and dd.donateDate =: datetime"),
})
public class DonateDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DND_ID;

    @Column
    private int money;

    @Column
    private LocalDateTime donateDate;

    @ManyToOne
    @JoinColumn(name = "dna_id")
    private DonateActivity donateActivity;
}

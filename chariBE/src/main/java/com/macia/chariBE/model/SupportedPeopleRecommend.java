package com.macia.chariBE.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.macia.chariBE.utility.EProcessingStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.supportedPeopleRecommend.findAll",
                query = "SELECT s FROM SupportedPeopleRecommend s order by s.SPR_ID desc"),
        @NamedQuery(name = "named.supportedPeopleRecommend.findById",
                query = "SELECT s FROM SupportedPeopleRecommend s where s.SPR_ID =:id"),
})
public class SupportedPeopleRecommend {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer SPR_ID;

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

    @ManyToOne
    @JoinColumn(name = "clb_id")
    private Collaborator collaborator;

    @Column()
    @Enumerated(EnumType.STRING)
    private EProcessingStatus status;

}

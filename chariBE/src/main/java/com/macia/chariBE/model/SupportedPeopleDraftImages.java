package com.macia.chariBE.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.supportedPeopleDraftImages.findByDraftId",
                query = "SELECT p FROM SupportedPeopleDraftImages p where p.supportedPeopleDraft.SPD_ID =:id"),
})
public class SupportedPeopleDraftImages {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer SDI_ID;

    @Column(length = 500)
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "spd_id")
    private SupportedPeopleDraft supportedPeopleDraft;
}

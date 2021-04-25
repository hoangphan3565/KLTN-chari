package com.macia.chariBE.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.donator_notification.findByDonatorId",
                query = "SELECT NEW com.macia.chariBE.DTO.DonatorNotificationDTO(dn.title,dn.message,dn.createTime,dn.projectID) FROM DonatorNotification dn where dn.donator.DNT_ID =:dnt_id"),
})
public class DonatorNotification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DNO_ID;

    @Column(length = 100)
    private String title;

    @Column(length = 200)
    private String message;

    @Column(length = 200)
    private Integer projectID;

    @CreationTimestamp
    @Column(length = 50)
    private LocalDateTime createTime;

    @Column(length = 200)
    private Boolean isRead;

    @ManyToOne
    @JoinColumn(name = "dnt_id")
    private Donator donator;
}

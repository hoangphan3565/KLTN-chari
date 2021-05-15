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
                query = "SELECT dn FROM DonatorNotification dn where dn.donator.DNT_ID =:dnt_id"),
        @NamedQuery(name = "named.donator_notification.findClosedNotiByProjectIdAndDonatorId",
                query = "SELECT dn FROM DonatorNotification dn where dn.project_id =:prj_id and dn.donator.DNT_ID =:dnt_id and dn.topic='closed'"),
})
public class DonatorNotification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DNO_ID;

    @Column(length = 100)
    private String topic;

    @Column(length = 100)
    private String title;

    @Column(length = 1000)
    private String message;

    @Column(length = 5)
    private Integer project_id;

    @CreationTimestamp
    @Column(length = 50)
    private LocalDateTime create_time;

    @Column()
    private Boolean is_read;

    @Column()
    private Boolean is_handled;

    @ManyToOne
    @JoinColumn(name = "dnt_id")
    private Donator donator;
}

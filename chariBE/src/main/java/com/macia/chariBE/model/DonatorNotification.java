package com.macia.chariBE.model;

import com.macia.chariBE.utility.ENotificationTopic;
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
                query = "SELECT dn FROM DonatorNotification dn " +
                        "where dn.donator.DNT_ID =:dnt_id order by dn.create_time desc "),
        @NamedQuery(name = "named.donator_notification.findByDonatorIdAndTitle",
                query = "SELECT dn FROM DonatorNotification dn " +
                        "where dn.donator.DNT_ID =:dnt_id and (lower(dn.title) like :skey or lower(dn.message) like :skey) order by dn.create_time desc "),
        @NamedQuery(name = "named.donator_notification.findAllClosedAndUnHandledNotification",
                query = "SELECT dn FROM DonatorNotification dn where dn.handled=false and dn.topic='CLOSED'"),
        @NamedQuery(name = "named.donator_notification.findClosedNotificationByProjectIdAndDonatorId",
                query = "SELECT dn FROM DonatorNotification dn where dn.project_id =:prj_id and dn.donator.DNT_ID =:dnt_id and dn.topic='CLOSED'"),
})
public class DonatorNotification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer DNO_ID;

    @Column()
    @Enumerated(EnumType.STRING)
    private ENotificationTopic topic;

    @Column(length = 100)
    private String title;

    @Column(length = 1000)
    private String message;

    @Column(length = 5)
    private Integer project_id;

    @Column(length = 1000)
    private String project_image;

    @CreationTimestamp
    @Column(length = 50)
    private LocalDateTime create_time;

    @Column()
    private Boolean read;

    @Column()
    private Boolean handled;

    @Column()
    private int total_money;

    @ManyToOne
    @JoinColumn(name = "dnt_id")
    private Donator donator;
}

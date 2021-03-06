package com.macia.chariBE.model;

import com.macia.chariBE.utility.ENotificationTopic;
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
public class PushNotification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer NOF_ID;

    @Column(length = 100)
    private String title;

    @Column(length = 200)
    private String description;

    @Column(length = 1000)
    private String message;

    @Column()
    @Enumerated(EnumType.STRING)
    private ENotificationTopic topic;
}

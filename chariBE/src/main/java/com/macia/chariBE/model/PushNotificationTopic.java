package com.macia.chariBE.model;

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
public class PushNotificationTopic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer TPC_ID;

    @Column(length = 50)
    private String TopicName;

    @Column(length = 200)
    private String Description;

    @JsonIgnore
    @OneToMany(mappedBy = "notificationTopic")
    private List<PushNotification> notifications;
}

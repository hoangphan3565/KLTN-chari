package com.macia.charitysystem.model;

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
public class Feedback {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer FEB_ID;

    @Column(length = 100)
    private String title;

    @Column(length = 500)
    private String description;

    @Column(length = 20)
    private String contributor;

}

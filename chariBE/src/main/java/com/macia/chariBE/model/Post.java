package com.macia.chariBE.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer POS_ID;

    @Column(length = 200)
    private String name;

    @Column(length = 200)
    private String projectId;

    @Column(length = 200)
    private String projectName;

    @Column(length = 20)
    private String projectStatus;

    @Column(length = 4000)
    private String content;

    @Column
    @CreationTimestamp
    private LocalDate createDate;

    @Column
    @UpdateTimestamp
    private LocalDate updateDate;

    @Column(length = 500)
    private String videoUrl;

    @JsonIgnore
    @OneToMany(fetch = FetchType.EAGER, mappedBy = "post")
    private List<PostImages> postImages;

}

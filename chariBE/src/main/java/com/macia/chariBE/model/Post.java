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
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.post.findAll",
                query = "SELECT p FROM Post p order by p.POS_ID desc"),
        @NamedQuery(name = "named.post.findLikePostName",
                query = "SELECT p FROM Post p where lower(p.name) like :name and p.isPublic=true order by p.publicTime desc"),
        @NamedQuery(name = "named.post.findPublic",
                query = "SELECT p FROM Post p where p.isPublic=true order by p.publicTime desc"),
        @NamedQuery(name = "named.post.findPostByCollaboratorId",
                query = "SELECT p FROM Post p where p.collaborator.CLB_ID =:id order by p.POS_ID desc"),
        @NamedQuery(name = "named.post.findById",
                query = "SELECT p FROM Post p where p.POS_ID =:id"),
})
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer POS_ID;

    @Column(length = 200)
    private String name;

    @Column(length = 4000)
    private String content;

    @Column()
    private Integer projectId;

    @Column()
    private Boolean isPublic;

    @Column
    @UpdateTimestamp
    private LocalDateTime publicTime;

    @Column(length = 500)
    private String imageUrl;

    @Column(length = 500)
    private String videoUrl;

    @ManyToOne
    @JoinColumn(name = "clb_id")
    private Collaborator collaborator;

    @JsonIgnore
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.EAGER, mappedBy = "post",orphanRemoval = true)
    private List<PostImages> postImages;

}

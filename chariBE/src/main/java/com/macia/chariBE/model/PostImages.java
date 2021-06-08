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
        @NamedQuery(name = "named.postImages.findByPostId",
                query = "SELECT p FROM PostImages p where p.post.POS_ID =:id"),
})
public class PostImages {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer POI_ID;

    @Column(length = 500)
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "pos_id")
    private Post post;
}

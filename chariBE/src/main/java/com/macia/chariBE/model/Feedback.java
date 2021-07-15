package com.macia.chariBE.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedQueries({
        @NamedQuery(name = "named.feedback.findAll",
                query = "SELECT feb FROM Feedback feb order by feb.FEB_ID desc"),
})
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

    @Column(length = 50)
    private String username;

    @Column()
    private Boolean isReply;

    @Column(length = 500)
    private String theReply;

    @Column
    @CreationTimestamp
    private LocalDateTime createTime;
}

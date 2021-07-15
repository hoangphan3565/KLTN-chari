package com.macia.chariBE.model;

import com.macia.chariBE.utility.EUserStatus;
import com.macia.chariBE.utility.EUserType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JwtUser implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column()
    private String username;

    @Column(length=500)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private EUserType usertype;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private EUserStatus status;

    @Column(length = 1000)
    private String fcmToken;
}
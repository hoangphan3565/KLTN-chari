package com.macia.charitysystem.DTO;

import com.macia.charitysystem.utility.UserType;
import lombok.*;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class JwtUserDTO {
    private String username;
    private String password1;
    private String password2;
    private UserType usertype;
}

package com.macia.charitysystem.DTO;

import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class JwtUserDTO {
    private String username;
    private String password1;
    private String password2;
    private String usertype;
}

package com.macia.chariBE.DTO;

import com.macia.chariBE.utility.UserType;
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
    private String fcmToken;
    private UserType usertype;
}

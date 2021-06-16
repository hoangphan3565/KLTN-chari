package com.macia.chariBE.DTO;

import com.macia.chariBE.utility.UserType;
import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    private String id;
    private String username;
    private String password1;
    private String password2;
    private String name;
    private String address;
    private String email;
    private String phone;
    private String certificate;
    private String fcmToken;
    private UserType usertype;
}

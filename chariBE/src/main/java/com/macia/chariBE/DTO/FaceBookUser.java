package com.macia.chariBE.DTO;

import com.macia.chariBE.utility.UserType;
import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FaceBookUser {
    private String name;
    private String id;
    private UserType usertype;
}

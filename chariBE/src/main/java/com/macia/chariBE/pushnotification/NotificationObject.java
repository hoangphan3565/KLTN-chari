package com.macia.chariBE.pushnotification;

import com.macia.chariBE.utility.ENotificationTopic;
import lombok.*;

@Builder
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class NotificationObject {
	private String title;
    private String message;
    private ENotificationTopic topic;
    private String token;

}
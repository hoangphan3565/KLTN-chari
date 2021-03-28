package com.macia.charitysystem.pushnotification;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class NotificationObject {
	private String title;
    private String message;
    private String topic;
    private String token;

}
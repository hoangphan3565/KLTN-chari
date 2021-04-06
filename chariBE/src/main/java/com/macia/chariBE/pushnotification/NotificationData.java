package com.macia.chariBE.pushnotification;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class NotificationData {
    private String title;
    private String message;
    private String image;
    private String timestamp;
    private String article_data;
    private String topic;
    private String token;
}

import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class PushNotificationService {  
  constructor(){ }
  public getPushNotifications = () => Api.get(Api.url.push_notifications);
  public savePushNotification = data => Api.post(Api.url.push_notifications,data);
}


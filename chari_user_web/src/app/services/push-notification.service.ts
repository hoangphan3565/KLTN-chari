import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { PushNotification } from '../models/PushNotification';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class PushNotificationService {  
  constructor( 
    private http: HttpClient){ }

  public getPushNotifications = async () => {
    try {
        const PushNotifications = await this.http.get(Api.baseUrl+Api.push_notifications);
        return await PushNotifications.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public savePushNotification = async (PushNotification: PushNotification) => {
    try {
        const PushNotifications = await this.http.post(Api.baseUrl+Api.push_notifications,PushNotification);
        return await PushNotifications.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
  public deletePushNotification = async (id: Number) => {
    try {
        const PushNotifications = await this.http.delete(Api.baseUrl+Api.push_notifications+'/'+id);
        return await PushNotifications.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


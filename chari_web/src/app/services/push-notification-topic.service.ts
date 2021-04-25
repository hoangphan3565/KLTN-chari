import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { PushNotificationTopic } from '../models/PushNotificationTopic';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class PushNotificationTopicService {  
  constructor( 
    private http: HttpClient){ }

  public getPushNotificationTopics = async () => {
    try {
        const PushNotificationTopics = await this.http.get(Api.baseUrl+Api.push_notification_topics);
        return await PushNotificationTopics.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  savePushNotificationTopic = async (PushNotificationTopic: PushNotificationTopic) => {
    try {
        const PushNotificationTopics = await this.http.post(Api.baseUrl+Api.push_notification_topics,PushNotificationTopic);
        return await PushNotificationTopics.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
  public deletePushNotificationTopic = async (id: Number) => {
    try {
        const PushNotificationTopics = await this.http.delete(Api.baseUrl+Api.push_notification_topics+'/'+id);
        return await PushNotificationTopics.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


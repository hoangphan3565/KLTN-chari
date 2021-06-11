import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { Feedback } from '../models/Feedback';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class FeedbackService {  
  constructor( 
    private http: HttpClient){ }

  public getFeedbacks = async () => {
    try {
        const Feedbacks = await this.http.get(Api.baseUrl+Api.feedbacks);
        return await Feedbacks.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
  public deleteFeedback = async (id: Number) => {
    try {
        const Feedbacks = await this.http.delete(Api.baseUrl+Api.feedbacks+'/'+id);
        return await Feedbacks.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


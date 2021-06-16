import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class FeedbackService {  
  constructor( ){ }
  public getFeedbacks = () => Api.get(Api.url.feedbacks);
  public deleteFeedback = id => Api.post(`${Api.url.feedbacks}/${id}`);
}


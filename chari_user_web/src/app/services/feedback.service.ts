import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class FeedbackService {  
  constructor( ){ }
  public countTotal = () => Api.get(`${Api.url.feedbacks}/count`)
  public getFeedbacks = (a,b) => Api.get(`${Api.url.feedbacks}/page/${a}/size/${b}`);
  public deleteFeedback = id => Api.delete(`${Api.url.feedbacks}/${id}`);
  public replyFeedback = data => Api.post(`${Api.url.feedbacks}/reply`,data);
}


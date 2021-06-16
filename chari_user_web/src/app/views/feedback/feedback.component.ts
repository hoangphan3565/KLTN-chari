import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Feedback } from '../../models/Feedback';
import { NotificationService } from '../../services/notification.service';
import { FeedbackService } from '../../services/feedback.service';

@Component({
  selector: 'app-feedback',
  templateUrl: './feedback.component.html',
})
export class FeedbackComponent implements OnInit {


  Feedbacks: Feedback[];
  // Feedback: Feedback;
  isEdit: boolean;

  constructor(
    private FeedbackService: FeedbackService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getFeedback()
  }
  public async getFeedback(){
    this.Feedbacks = await (await this.FeedbackService.getFeedbacks()).data as Feedback[];
  }


  public deleteFeedback = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá phản hồi này?')){
        const result = await this.FeedbackService.deleteFeedback(id);
        if (result)
        {
          this.notificationService.warn('Xoá phản hồi thành công');
          this.Feedbacks = result.data as Feedback[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

}

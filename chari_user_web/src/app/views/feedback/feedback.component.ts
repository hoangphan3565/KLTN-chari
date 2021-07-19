import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Feedback } from '../../models/Feedback';
import { NotificationService } from '../../services/notification.service';
import { FeedbackService } from '../../services/feedback.service';
import { DialogReplyComponent } from './dialog-reply/dialog-reply.component';

@Component({
  selector: 'app-feedback',
  templateUrl: './feedback.component.html',
})
export class FeedbackComponent implements OnInit {


  Feedbacks: Feedback[];
  Feedback: Feedback;
  isEdit: boolean;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;
  

  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getFeedback(this.currentPage,this.itemsPerPage);
  }

  public options = [
    {"id": 1, "value": 5},
    {"id": 2, "value": 10},
    {"id": 3, "value": 25},
    {"id": 4, "value": 100},
  ]
  public selected1 = this.options[0].id;

  rowsChanged(event: any): void {
    this.itemsPerPage = this.options[event.value-1].value;
    this.getFeedback(this.currentPage,this.itemsPerPage);
  }

  constructor(
    private FeedbackService: FeedbackService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getTotalFeedback()
    this.getFeedback(1,this.itemsPerPage)
  }
  public async getTotalFeedback(){
    this.totalItems = await (await this.FeedbackService.countTotal()).data;
  }
  public async getFeedback(a,b){
    this.Feedbacks = await (await this.FeedbackService.getFeedbacks(a,b)).data as Feedback[];
  }


  public deleteFeedback = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá phản hồi này?')){
        const res = await (await this.FeedbackService.deleteFeedback(id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getFeedback(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }  

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogReplyComponent, {
      width: '500px',
      data: this.Feedback,
    });
    dialogRef.afterClosed().subscribe((res: Feedback) => {
      if(res){
        this.replyFeedback(res);
      }
    });
  }
  openReplyFeedbackDialog(p : Feedback): void {
    this.Feedback = {
      feb_ID: p.feb_ID,
      title:p.title,
      description:p.description,
      contributor:p.contributor,
      username:p.username,
      isReply:p.isReply,
      theReply:"",
    }; 
    this.openDialog();
  }
  clearData(){
    this.Feedback = {
      feb_ID: null,
      title:"",
      description:"",
      contributor:"",
      username:"",
      isReply:null,
      theReply:"",
    }; 
  }
  public replyFeedback = async (data) => {
    try 
    {
      const res = await (await this.FeedbackService.replyFeedback(data)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getFeedback(this.currentPage,this.itemsPerPage);
      }  
    }
    catch (e) {
      console.log(e);
    }
  }

}

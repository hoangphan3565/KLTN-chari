import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { NotificationService } from '../../../services/notification.service';
import { Feedback } from '../../../models/Feedback';

@Component({
    templateUrl: './dialog-reply.component.html',
})
export class DialogReplyComponent implements OnInit {

  
  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogReplyComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Feedback) { 
      dialogRef.disableClose = true;
    }

  ngOnInit(): void {
  }

  save(){
    if(this.data.theReply==''){
      this.notificationService.warn('Hãy điền câu trả lời')
      return;
    } else{
      this.dialogRef.close(this.data);
    }
  }
}
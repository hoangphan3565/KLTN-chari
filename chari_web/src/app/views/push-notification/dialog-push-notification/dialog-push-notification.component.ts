import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { PushNotification } from '../../../models/PushNotification';
import { NotificationService } from '../../../services/notification.service';

@Component({
    selector: 'app-dialog-push-notification',
    templateUrl: './dialog-push-notification.component.html',
    styleUrls: ['../../../app.component.css']
  })
  export class DialogPushNotificationComponent implements OnInit {


    constructor(
      public dialogRef: MatDialogRef<DialogPushNotificationComponent>,
      private notificationService: NotificationService,
      @Inject(MAT_DIALOG_DATA) public data: PushNotification) { 
        dialogRef.disableClose = true;
      }
  
    ngOnInit(): void {
    }

    save(){
      if(this.data.title=='' || this.data.message==''){
        this.notificationService.warn('Không được trống thông tin nào');
      }else{
        this.dialogRef.close(this.data);
      }
    }
  }
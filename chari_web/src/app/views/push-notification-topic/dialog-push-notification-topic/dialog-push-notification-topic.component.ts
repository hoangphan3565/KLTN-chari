import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { PushNotificationTopic } from '../../../models/PushNotificationTopic';
import { NotificationService } from '../../../services/notification.service';

@Component({
    selector: 'app-dialog-push-notification-topic',
    templateUrl: './dialog-push-notification-topic.component.html',
  })
  export class DialogPushNotificationTopicComponent implements OnInit {
    constructor(
      private notificationService: NotificationService,
      public dialogRef: MatDialogRef<DialogPushNotificationTopicComponent>,
      @Inject(MAT_DIALOG_DATA) public data: PushNotificationTopic) { }
  
    ngOnInit(): void {
    }
  
    save(){
      if(this.data.topicName=='' || this.data.description==''){
        this.notificationService.warn('Không được trống thông tin nào!');
      }else{
        this.dialogRef.close(this.data);
      }
    }
  }
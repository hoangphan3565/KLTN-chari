import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { PushNotification } from '../../../models/PushNotification';
import { PushNotificationTopic } from '../../../models/PushNotificationTopic';
import { PushNotificationTopicService } from '../../../services/push-notification-topic.service';

@Component({
    selector: 'app-dialog-push-notification',
    templateUrl: './dialog-push-notification.component.html',
  })
  export class DialogPushNotificationComponent implements OnInit {
    PushNotificationTopics: PushNotificationTopic[];

    constructor(
      public dialogRef: MatDialogRef<DialogPushNotificationComponent>,
      private PushNotificationTopicService: PushNotificationTopicService,
      @Inject(MAT_DIALOG_DATA) public data: PushNotification) { }
  
    ngOnInit(): void {
      this.getPushNotificationTopic();
    }
    public async getPushNotificationTopic(){
      this.PushNotificationTopics = await this.PushNotificationTopicService.getPushNotificationTopics() as PushNotificationTopic[];
    }
  
  
    save(){
      this.dialogRef.close(this.data);
    }
  }
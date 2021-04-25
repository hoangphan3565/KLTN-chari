import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { PushNotificationTopic } from '../../../models/PushNotificationTopic';

@Component({
    selector: 'app-dialog-push-notification-topic',
    templateUrl: './dialog-push-notification-topic.component.html',
  })
  export class DialogPushNotificationTopicComponent implements OnInit {
    constructor(
      public dialogRef: MatDialogRef<DialogPushNotificationTopicComponent>,
      @Inject(MAT_DIALOG_DATA) public data: PushNotificationTopic) { }
  
    ngOnInit(): void {
    }
  
    save(){
        this.dialogRef.close(this.data);
    }
  }
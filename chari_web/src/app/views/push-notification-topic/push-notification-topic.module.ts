import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PushNotificationTopicComponent } from './push-notification-topic.component';
import { PushNotificationTopicRoutingModule } from './push-notification-topic-routing.module';
import { DialogPushNotificationTopicComponent } from './dialog-push-notification-topic/dialog-push-notification-topic.component';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  imports: [
    CommonModule,
    PushNotificationTopicRoutingModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    PushNotificationTopicComponent,
    DialogPushNotificationTopicComponent ]
})
export class PushNotificationTopicModule { }

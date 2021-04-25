import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PushNotificationComponent } from './push-notification.component';
import { PushNotificationRoutingModule } from './push-notification-routing.module';
import { DialogPushNotificationComponent } from './dialog-push-notification/dialog-push-notification.component';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatOptionModule } from '@angular/material/core';

@NgModule({
  imports: [
  CommonModule,
    PushNotificationRoutingModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatOptionModule,
  ],
  declarations: [ 
    PushNotificationComponent,
    DialogPushNotificationComponent ]
})
export class PushNotificationModule { }

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PushNotificationComponent } from './push-notification.component';
import { PushNotificationRoutingModule } from './push-notification-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  imports: [
    CommonModule,
    PushNotificationRoutingModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    PushNotificationComponent,
    ]
})
export class PushNotificationModule { }

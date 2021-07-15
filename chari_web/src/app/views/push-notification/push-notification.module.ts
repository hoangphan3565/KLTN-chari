import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PushNotificationComponent } from './push-notification.component';
import { PushNotificationRoutingModule } from './push-notification-routing.module';
import { DialogPushNotificationComponent } from './dialog-push-notification/dialog-push-notification.component';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material-module';

@NgModule({
  imports: [
  CommonModule,
    PushNotificationRoutingModule,
    FormsModule,
    MaterialModule,
    TooltipModule.forRoot()
  ],
  declarations: [ 
    PushNotificationComponent,
    DialogPushNotificationComponent ]
})
export class PushNotificationModule { }

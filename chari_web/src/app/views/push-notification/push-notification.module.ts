import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PushNotificationComponent } from './push-notification.component';
import { PushNotificationRoutingModule } from './push-notification-routing.module';

@NgModule({
  imports: [
    CommonModule,
    PushNotificationRoutingModule,
  ],
  declarations: [ 
    PushNotificationComponent,
  ]
})
export class PushNotificationModule { }

import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PushNotificationComponent } from './push-notification.component';

const routes: Routes = [
  {
    path: '',
    component: PushNotificationComponent,
    data: {
      title: 'Thông báo đẩy'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PushNotificationRoutingModule {}

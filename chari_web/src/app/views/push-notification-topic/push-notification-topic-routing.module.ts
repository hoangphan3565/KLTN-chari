import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PushNotificationTopicComponent } from './push-notification-topic.component';

const routes: Routes = [
  {
    path: '',
    component: PushNotificationTopicComponent,
    data: {
      title: 'Cộng tác viên'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PushNotificationTopicRoutingModule {}

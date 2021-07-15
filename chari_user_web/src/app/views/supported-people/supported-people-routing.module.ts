import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { SupportedPeopleComponent } from './supported-people.component';

const routes: Routes = [
  {
    path: '',
    component: SupportedPeopleComponent,
    data: {
      title: 'Người thụ hưởng'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SupportedPeopleRoutingModule {}

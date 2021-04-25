import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { DonatorComponent } from './donator.component';

const routes: Routes = [
  {
    path: '',
    component: DonatorComponent,
    data: {
      title: 'Nhà từ thiện'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DonatorRoutingModule {}

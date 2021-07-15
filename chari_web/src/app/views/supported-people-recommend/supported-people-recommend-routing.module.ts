import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { SupportedPeopleRecommendComponent } from './supported-people-recommend.component';

const routes: Routes = [
  {
    path: '',
    component: SupportedPeopleRecommendComponent,
    data: {
      title: 'Hoàn cảnh khác'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SupportedPeopleRecommendRoutingModule {}

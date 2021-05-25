import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectUnverifiedComponent } from './project-unverified.component';

const routes: Routes = [
  {
    path: '',
    component: ProjectUnverifiedComponent,
    data: {
      title: 'Dự án chờ phê duyệt'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectUnverifiedRoutingModule {}

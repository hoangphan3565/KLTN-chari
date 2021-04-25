import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectReachedComponent } from './project-reached.component';

const routes: Routes = [
  {
    path: '',
    component: ProjectReachedComponent,
    data: {
      title: 'Chờ phê duyệt'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectReachedRoutingModule {}

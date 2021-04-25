import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectFailedComponent } from './project-failed.component';

const routes: Routes = [
  {
    path: '',
    component: ProjectFailedComponent,
    data: {
      title: 'Chờ phê duyệt'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectFailedRoutingModule {}

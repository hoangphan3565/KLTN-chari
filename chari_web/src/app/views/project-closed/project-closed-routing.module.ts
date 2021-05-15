import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectClosedComponent } from './project-closed.component';

const routes: Routes = [
  {
    path: '',
    component: ProjectClosedComponent,
    data: {
      title: 'Chờ phê duyệt'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectClosedRoutingModule {}

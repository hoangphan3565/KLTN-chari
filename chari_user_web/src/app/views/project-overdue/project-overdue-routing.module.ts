import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectOverdueComponent } from './project-overdue.component';

const routes: Routes = [
  {
    path: '',
    component: ProjectOverdueComponent,
    data: {
      title: 'Dự án quá hạn'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectOverdueRoutingModule {}


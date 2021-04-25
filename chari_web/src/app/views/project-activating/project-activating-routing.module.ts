import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectActivatingComponent } from './project-activating.component';


const routes: Routes = [
  {
    path: '',
    component: ProjectActivatingComponent,
    data: {
      title: 'Đang hoạt động'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectActivatingRoutingModule {}

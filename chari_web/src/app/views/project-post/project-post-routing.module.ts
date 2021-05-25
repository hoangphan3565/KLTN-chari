import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ProjectPostComponent } from './project-post.component';

const routes: Routes = [
  {
    path: '',
    component: ProjectPostComponent,
    data: {
      title: 'Bài viết từ thiện'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectPostRoutingModule {}

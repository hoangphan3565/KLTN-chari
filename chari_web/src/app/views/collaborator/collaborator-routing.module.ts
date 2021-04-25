import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { CollaboratorComponent } from './collaborator.component';

const routes: Routes = [
  {
    path: '',
    component: CollaboratorComponent,
    data: {
      title: 'Cộng tác viên'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CollaboratorRoutingModule {}

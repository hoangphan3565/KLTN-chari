import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectClosedComponent } from './project-closed.component';
import { ProjectClosedRoutingModule } from './project-closed-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import { PaginationModule } from 'ngx-bootstrap/pagination';

@NgModule({
  imports: [
    CommonModule,
    ProjectClosedRoutingModule,
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    PaginationModule.forRoot(),

  ],
  declarations: [ 
    ProjectClosedComponent,
    DialogDisburseProjectComponent,
  ]
})
export class ProjectClosedModule { }

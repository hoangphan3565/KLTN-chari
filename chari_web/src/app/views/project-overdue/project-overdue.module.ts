import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectOverdueComponent } from './project-overdue.component';
import { ProjectOverdueRoutingModule } from './project-overdue-routing.module';
import { DialogExtendComponent } from './dialog-extend/dialog-extend.component';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormsModule } from '@angular/forms';
import { MatDialogModule } from '@angular/material/dialog';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import { PaginationModule } from 'ngx-bootstrap/pagination';


@NgModule({
  imports: [
  CommonModule,
    ProjectOverdueRoutingModule,
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    PaginationModule.forRoot(),

  ],
  declarations: [ 
    ProjectOverdueComponent,
    DialogExtendComponent,
    DialogDisburseProjectComponent,
  ]
})
export class ProjectOverdueModule { }

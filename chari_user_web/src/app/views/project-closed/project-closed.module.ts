import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectClosedComponent } from './project-closed.component';
import { ProjectClosedRoutingModule } from './project-closed-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material/material-module';

@NgModule({
  imports: [
    CommonModule,
    ProjectClosedRoutingModule,
    FormsModule,
    MaterialModule,
    PaginationModule.forRoot(),
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    ProjectClosedComponent,
  ]
})
export class ProjectClosedModule { }

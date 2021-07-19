import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectClosedComponent } from './project-closed.component';
import { ProjectClosedRoutingModule } from './project-closed-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material-module';

@NgModule({
  imports: [
    CommonModule,
    ProjectClosedRoutingModule,
    FormsModule,
    PaginationModule.forRoot(),
    TooltipModule.forRoot(),
    MaterialModule,
  ],
  declarations: [ 
    ProjectClosedComponent,
  ]
})
export class ProjectClosedModule { }

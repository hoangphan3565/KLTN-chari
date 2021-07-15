import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectTypeComponent } from './project-type.component';
import { ProjectTypeRoutingModule } from './project-type-routing.module';
import { DialogProjectTypeComponent } from './dialog-project-type/dialog-project-type.component';
import { ProjectTypeDragDropDirective } from './drag-drop.directive';
import { MaterialModule } from '../../material-module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { FormsModule } from '@angular/forms';


@NgModule({
  imports: [
    CommonModule,
    ProjectTypeRoutingModule,
    FormsModule,
    MaterialModule,
    PaginationModule.forRoot(),
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    ProjectTypeComponent,
    DialogProjectTypeComponent,
    ProjectTypeDragDropDirective,
  ]
})
export class ProjectTypeModule { }

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectTypeComponent } from './project-type.component';
import { ProjectTypeRoutingModule } from './project-type-routing.module';
import { DialogProjectTypeComponent } from './dialog-project-type/dialog-project-type.component';
import { MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormsModule } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { ProjectTypeDragDropDirective } from './drag-drop.directive';
import { MaterialModule } from '../../material-module';
import { PaginationModule } from 'ngx-bootstrap/pagination';


@NgModule({
  imports: [
    CommonModule,
    ProjectTypeRoutingModule,
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MaterialModule,
    PaginationModule.forRoot(),
  ],
  declarations: [ 
    ProjectTypeComponent,
    DialogProjectTypeComponent,
    ProjectTypeDragDropDirective,
  ]
})
export class ProjectTypeModule { }

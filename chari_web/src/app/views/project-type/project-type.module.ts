import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectTypeComponent } from './project-type.component';
import { ProjectTypeRoutingModule } from './project-type-routing.module';
import { DialogProjectTypeComponent } from './dialog-project-type/dialog-project-type.component';
import { MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormsModule } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  imports: [
  CommonModule,
    ProjectTypeRoutingModule,
    MatDialogModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    ProjectTypeComponent,
    DialogProjectTypeComponent,
  ]
})
export class ProjectTypeModule { }

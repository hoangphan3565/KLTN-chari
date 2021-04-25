import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectUnverifiedComponent } from './project-unverified.component';
import { ProjectUnverifiedRoutingModule } from './project-unverified-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  imports: [
    CommonModule,
    ProjectUnverifiedRoutingModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    ProjectUnverifiedComponent,
  ]
})
export class ProjectUnverifiedModule { }

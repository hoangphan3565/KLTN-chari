import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectUnverifiedComponent } from './project-unverified.component';
import { ProjectUnverifiedRoutingModule } from './project-unverified-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { PaginationModule } from 'ngx-bootstrap/pagination';

@NgModule({
  imports: [
    CommonModule,
    ProjectUnverifiedRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    ProjectUnverifiedComponent,
  ]
})
export class ProjectUnverifiedModule { }

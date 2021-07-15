import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CollaboratorComponent } from './collaborator.component';
import { CollaboratorRoutingModule } from './collaborator-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material-module';

@NgModule({
  imports: [
  CommonModule,
    CollaboratorRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    TooltipModule.forRoot(),

  ],
  declarations: [ 
    CollaboratorComponent,
  ]
})
export class CollaboratorModule { }

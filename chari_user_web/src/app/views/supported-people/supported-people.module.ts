import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SupportedPeopleComponent } from './supported-people.component';
import { SupportedPeopleRoutingModule } from './supported-people-routing.module';
import { DialogSupportedPeopleComponent } from './dialog-supported-people/dialog-supported-people.component';
import { MatDialogModule } from '@angular/material/dialog';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  imports: [
    CommonModule,
    SupportedPeopleRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule  ],
  declarations: [ 
    SupportedPeopleComponent,
    DialogSupportedPeopleComponent, 
  ]
})
export class SupportedPeopleModule { }

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DonatorComponent } from './donator.component';
import { DonatorRoutingModule } from './donator-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { PaginationModule } from 'ngx-bootstrap/pagination';

@NgModule({
  imports: [
    CommonModule,
    DonatorRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    DonatorComponent,
  ]
})
export class DonatorModule { }

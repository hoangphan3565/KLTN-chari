import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DonatorComponent } from './donator.component';
import { DonatorRoutingModule } from './donator-routing.module';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material-module';

@NgModule({
  imports: [
    CommonModule,
    DonatorRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    MatFormFieldModule,
    TooltipModule.forRoot(),

  ],
  declarations: [ 
    DonatorComponent,
  ]
})
export class DonatorModule { }

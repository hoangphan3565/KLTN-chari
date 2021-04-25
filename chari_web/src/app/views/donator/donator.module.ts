import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DonatorComponent } from './donator.component';
import { DonatorRoutingModule } from './donator-routing.module';
import { DialogDonatorComponent } from './dialog-donator/dialog-donator.component';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  imports: [
    CommonModule,
    DonatorRoutingModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule
  ],
  declarations: [ 
    DonatorComponent,
    DialogDonatorComponent ]
})
export class DonatorModule { }

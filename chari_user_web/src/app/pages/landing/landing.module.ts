import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material/material-module';
import { LadingComponent } from './landing.component';

@NgModule({
  imports: [
    CommonModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MaterialModule,

  ],
  declarations: [ 
    LadingComponent,
  ]
})
export class PLadingModule { }

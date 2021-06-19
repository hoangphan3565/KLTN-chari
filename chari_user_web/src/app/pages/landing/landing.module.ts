import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material/material-module';
import { LandingComponent } from './landing.component';

@NgModule({
  imports: [
    CommonModule,
    MatDialogModule,
    FormsModule,
    MaterialModule,

  ],
  declarations: [ 
    LandingComponent,
  ]
})
export class PLadingModule { }

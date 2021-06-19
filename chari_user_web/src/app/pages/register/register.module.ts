import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule } from '@angular/material/dialog';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material/material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { RegisterComponent } from './register.component';

@NgModule({
  imports: [
    CommonModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud")
  ],
  declarations: [ 
    RegisterComponent,
  ]
})
export class RegisterModule { }

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SupportedPeopleComponent } from './supported-people.component';
import { SupportedPeopleRoutingModule } from './supported-people-routing.module';
import { DialogSupportedPeopleComponent } from './dialog-supported-people/dialog-supported-people.component';
import { FormsModule } from '@angular/forms';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { DialogProjectAddComponent } from './dialog-project/dialog-project.component';
import { MaterialModule } from '../../material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { TooltipModule } from 'ngx-bootstrap/tooltip';

@NgModule({
  imports: [
    CommonModule,
    SupportedPeopleRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    CommonModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"), 
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    SupportedPeopleComponent,
    DialogSupportedPeopleComponent,
    DialogProjectAddComponent
  ]
})
export class SupportedPeopleModule { }

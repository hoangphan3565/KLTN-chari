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
import { DialogProjectAddComponent } from './dialog-project/dialog-project.component';
import { MaterialModule } from '../../material/material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { VideoDragDropDirective } from './drag-drop.directive';
import { ImageDragDropDirective } from './image-drag-drop.directive';

@NgModule({
  imports: [
    CommonModule,
    SupportedPeopleRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    CommonModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
    TooltipModule.forRoot(),

  ],
  declarations: [ 
    SupportedPeopleComponent,
    DialogSupportedPeopleComponent, 
    DialogProjectAddComponent,
    VideoDragDropDirective,
    ImageDragDropDirective,
  ]
})
export class SupportedPeopleModule { }

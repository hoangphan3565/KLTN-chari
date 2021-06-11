import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AngularFireModule } from "@angular/fire";
import { AngularFireStorageModule } from "@angular/fire/storage";
import { environment } from '../../../environments/environment';

import { ProjectComponent } from './project.component';
import { ProjectRoutingModule } from './project-routing.module';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AlertModule } from 'ngx-bootstrap/alert';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material-module';
import { DragDropDirective } from './drag-drop.directive';
import { VideoDragDropDirective } from './video-drag-drop.directive';

@NgModule({
  imports: [
  CommonModule,
    ProjectRoutingModule,
    MatDialogModule,
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud")
  ],
  declarations: [ 
    ProjectComponent,
    DialogProjectComponent,
    DragDropDirective,
    VideoDragDropDirective,
  ]
})
export class ProjectModule { }

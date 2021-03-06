import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AngularFireModule } from "@angular/fire";
import { AngularFireStorageModule } from "@angular/fire/storage";
import { environment } from '../../../environments/environment';

import { ProjectComponent } from './project.component';
import { ProjectRoutingModule } from './project-routing.module';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material/material-module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { VideoDragDropDirective } from './drag-drop.directive';

@NgModule({
  imports: [
  CommonModule,
    ProjectRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    ProjectComponent,
    DialogProjectComponent,
    VideoDragDropDirective
  ]
})
export class ProjectModule { }

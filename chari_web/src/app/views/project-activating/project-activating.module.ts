import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectActivatingComponent } from './project-activating.component';
import { ProjectActivatingRoutingModule } from './project-activating-routing.module';
import { FormsModule } from '@angular/forms';
import { DialogPostActivatingComponent } from './dialog-post/dialog-post.component';
import { MaterialModule } from '../../material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';
import { VideoDragDropDirective } from './drag-drop.directive';

@NgModule({
  imports: [
  CommonModule,
    ProjectActivatingRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    ProjectActivatingComponent,
    DialogProjectComponent,
    DialogPostActivatingComponent,
    VideoDragDropDirective
  ]
})
export class ProjectActivatingModule { }

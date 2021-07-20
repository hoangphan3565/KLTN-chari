import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectReachedComponent } from './project-reached.component';
import { ProjectReachedRoutingModule } from './project-reached-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material/material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { VideoDragDropDirective } from './drag-drop.directive';
import { ImageDragDropDirective } from './image-drag-drop.directive';

@NgModule({
  imports: [
    CommonModule,
    ProjectReachedRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
    TooltipModule.forRoot(),

  ],
  declarations: [ 
    ProjectReachedComponent,
    DialogPostComponent,
    VideoDragDropDirective,
    ImageDragDropDirective,
  ]
})
export class ProjectReachedModule { }

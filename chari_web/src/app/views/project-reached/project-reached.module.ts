import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectReachedComponent } from './project-reached.component';
import { ProjectReachedRoutingModule } from './project-reached-routing.module';
import { FormsModule } from '@angular/forms';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import { MaterialModule } from '../../material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { DialogPostReachedComponent } from './dialog-post/dialog-post.component';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { ImageDragDropDirective } from './image-drag-drop.directive';
import { VideoDragDropDirective } from './video-drag-drop.directive';


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
    DialogDisburseProjectComponent,
    DialogPostReachedComponent,
    ImageDragDropDirective,
    VideoDragDropDirective,
  ]
})
export class ProjectReachedModule { }

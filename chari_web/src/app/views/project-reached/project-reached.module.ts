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
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import { PostImageDragDropDirective } from './post-image-drag-drop.directive';
import { PostVideoDragDropDirective } from './post-video-drag-drop.directive';
import { PaginationModule } from 'ngx-bootstrap/pagination';
@NgModule({
  imports: [
    CommonModule,
    ProjectReachedRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
  ],
  declarations: [ 
    ProjectReachedComponent,
    DialogDisburseProjectComponent,
    DialogPostComponent,
    PostImageDragDropDirective,
    PostVideoDragDropDirective
  ]
})
export class ProjectReachedModule { }

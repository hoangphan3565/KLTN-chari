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
import { PostImageDragDropDirective } from './post-image-drag-drop.directive';
import { PostVideoDragDropDirective } from './post-video-drag-drop.directive';

@NgModule({
  imports: [
    CommonModule,
    ProjectReachedRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud")
  ],
  declarations: [ 
    ProjectReachedComponent,
    DialogPostComponent,
    PostImageDragDropDirective,
    PostVideoDragDropDirective
  ]
})
export class ProjectReachedModule { }

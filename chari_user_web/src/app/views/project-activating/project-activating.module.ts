import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectActivatingComponent } from './project-activating.component';
import { ProjectActivatingRoutingModule } from './project-activating-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule } from '@angular/forms';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import { PostImageDragDropDirective } from './post-image-drag-drop.directive';
import { PostVideoDragDropDirective } from './post-video-drag-drop.directive';
import { MaterialModule } from '../../material/material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';

@NgModule({
  imports: [
    CommonModule,
    ProjectActivatingRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud")
  ],
  declarations: [ 
    ProjectActivatingComponent,
    DialogPostComponent,
    PostImageDragDropDirective,
    PostVideoDragDropDirective
  ]
})
export class ProjectActivatingModule { }

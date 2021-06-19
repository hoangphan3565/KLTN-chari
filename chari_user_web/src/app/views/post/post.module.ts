import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PostComponent } from './post.component';
import { PostRoutingModule } from './post-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { PostImageDragDropDirective } from './post-image-drag-drop.directive';
import { PostVideoDragDropDirective } from './post-video-drag-drop.directive';
import { MaterialModule } from '../../material/material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import { PaginationModule } from 'ngx-bootstrap/pagination';

@NgModule({
  imports: [
    CommonModule,
    PostRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud")
  ],
  declarations: [ 
    PostComponent,
    DialogPostComponent,
    PostImageDragDropDirective,
    PostVideoDragDropDirective
  ]
})
export class ProjectPostModule { }

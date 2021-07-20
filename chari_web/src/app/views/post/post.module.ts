import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PostComponent } from './post.component';
import { PostRoutingModule } from './post-routing.module';
import { MatDialogModule } from '@angular/material/dialog';
import { FormsModule } from '@angular/forms';
import { MaterialModule } from '../../material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { VideoDragDropDirective } from './video-drag-drop.directive';
import { ImageDragDropDirective } from './image-drag-drop.directive';


@NgModule({
  imports: [
   CommonModule,
    PostRoutingModule,
    MatDialogModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    PostComponent,
    DialogPostComponent,
    VideoDragDropDirective,
    ImageDragDropDirective,
  ]
})
export class ProjectPostModule { }

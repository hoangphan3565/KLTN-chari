import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectActivatingComponent } from './project-activating.component';
import { ProjectActivatingRoutingModule } from './project-activating-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule } from '@angular/forms';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import { MaterialModule } from '../../material/material-module';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { DialogDonateInfoComponent } from './dialog-donateinfo-project/dialog-donateinfo-project.component';

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
    DialogDonateInfoComponent,
  ]
})
export class ProjectActivatingModule { }

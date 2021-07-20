import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProjectUnverifiedComponent } from './project-unverified.component';
import { ProjectUnverifiedRoutingModule } from './project-unverified-routing.module';
import { FormsModule } from '@angular/forms';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material-module';
import { DialogApproveProjectComponent } from './dialog-approve-project/dialog-project.component';
import { ImageDragDropDirective } from './image-drag-drop.directive';
import { VideoDragDropDirective } from './video-drag-drop.directive';

@NgModule({
  imports: [
CommonModule,
    ProjectUnverifiedRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    TooltipModule.forRoot(),
  ],
  declarations: [ 
    ProjectUnverifiedComponent,
    DialogApproveProjectComponent,
    ImageDragDropDirective,
    VideoDragDropDirective,
  ]
})
export class ProjectUnverifiedModule { }

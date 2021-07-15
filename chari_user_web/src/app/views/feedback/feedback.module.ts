import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FeedbackComponent } from './feedback.component';
import { FeedbackRoutingModule } from './feedback-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material/material-module';
import { FormsModule } from '@angular/forms';
import { DialogReplyComponent } from './dialog-reply/dialog-reply.component';

@NgModule({
  imports: [
    CommonModule,
    FeedbackRoutingModule,
    PaginationModule.forRoot(),
    TooltipModule.forRoot(),
    MaterialModule,
    FormsModule,
  ],
  declarations: [ 
    FeedbackComponent, 
    DialogReplyComponent,
  ]
})
export class FeedbackModule { }

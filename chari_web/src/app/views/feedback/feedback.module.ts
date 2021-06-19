import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FeedbackComponent } from './feedback.component';
import { FeedbackRoutingModule } from './feedback-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';

@NgModule({
  imports: [
    CommonModule,
    FeedbackRoutingModule,
    PaginationModule.forRoot(),
  ],
  declarations: [ FeedbackComponent ]
})
export class FeedbackModule { }

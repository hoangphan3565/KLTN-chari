import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FeedbackComponent } from './feedback.component';
import { FeedbackRoutingModule } from './feedback-routing.module';

@NgModule({
  imports: [
    CommonModule,
    FeedbackRoutingModule,
  ],
  declarations: [ FeedbackComponent ]
})
export class FeedbackModule { }

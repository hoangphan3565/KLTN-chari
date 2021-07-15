import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DialogSupportedPeopleRecommendComponent } from './dialog-supported-people-recommend/dialog-supported-people-recommend.component';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule } from '@angular/forms';
import { DialogProjectAddComponent } from './dialog-project/dialog-project.component';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../../../environments/environment';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { SupportedPeopleRecommendRoutingModule } from './supported-people-recommend-routing.module';
import { SupportedPeopleRecommendComponent } from './supported-people-recommend.component';
import { MaterialModule } from '../../material-module';
@NgModule({
  imports: [
    CommonModule,
    SupportedPeopleRecommendRoutingModule,
    PaginationModule.forRoot(),
    FormsModule,
    MaterialModule,
    AngularFireStorageModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, "cloud"),
    TooltipModule.forRoot(),

  ],
  declarations: [ 
    SupportedPeopleRecommendComponent,
    DialogSupportedPeopleRecommendComponent, 
    DialogProjectAddComponent,
  ]
})
export class SupportedPeopleRecommendModule { }

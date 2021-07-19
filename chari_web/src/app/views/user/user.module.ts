import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { UserComponent } from './user.component';
import { UserRoutingModule } from './user-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { MaterialModule } from '../../material-module';
import { FormsModule } from '@angular/forms';

@NgModule({
  imports: [
    CommonModule,
    UserRoutingModule,
    FormsModule,
    PaginationModule.forRoot(),
    TooltipModule.forRoot(),
    MaterialModule,
  ],
  declarations: [ UserComponent ]
})
export class UserModule { }

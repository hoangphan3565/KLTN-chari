import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { UserComponent } from './user.component';
import { UserRoutingModule } from './user-routing.module';
import { PaginationModule } from 'ngx-bootstrap/pagination';

@NgModule({
  imports: [
    CommonModule,
    UserRoutingModule,
    PaginationModule.forRoot(),

  ],
  declarations: [ UserComponent ]
})
export class UserModule { }

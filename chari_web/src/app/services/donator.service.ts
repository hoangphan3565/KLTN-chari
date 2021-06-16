import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class DonatorService {  
  constructor( ){ }
  public getDonators = () => Api.get(Api.url.donators);

}


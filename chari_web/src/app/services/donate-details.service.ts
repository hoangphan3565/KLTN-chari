import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class DonateDetailsService {  
  constructor(){ }
  public saveDonateWithBank = data => Api.post(`${Api.url.donate_details}/donate_with_bank`,data);
  public disburseWithBank = data => Api.post(`${Api.url.donate_details}/disburse_with_bank`,data);
}


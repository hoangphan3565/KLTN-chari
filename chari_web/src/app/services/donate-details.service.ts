import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class DonateDetailsService {  
  constructor(){ }
  public saveDonateWithBankDetail = data => Api.post(`${Api.url.donate_details}/donate_with_bank`,data);
}


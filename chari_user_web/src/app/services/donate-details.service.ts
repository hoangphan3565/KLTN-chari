import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { DonateDetail } from '../models/DonateDetail';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class DonateDetailsService {  
  constructor( 
    private http: HttpClient){ }


  
  public  saveDonateWithBankDetail = async (DonateDetail: any) => {
    try {
        const DonateDetailss = await this.http.post(Api.baseUrl+Api.donate_details+'/donate_with_bank',DonateDetail);
        return await DonateDetailss.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
}


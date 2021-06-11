import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { Donator } from '../models/Donator';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class DonatorService {  
  constructor( 
    private http: HttpClient){ }

  public getDonators = async () => {
    try {
        const Donators = await this.http.get(Api.baseUrl+Api.donators);
        return await Donators.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  saveDonator = async (Donator: Donator) => {
    try {
        const Donators = await this.http.post(Api.baseUrl+Api.donators,Donator);
        return await Donators.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
  public deleteDonator = async (id: Number) => {
    try {
        const Donators = await this.http.delete(Api.baseUrl+Api.donators+'/'+id);
        return await Donators.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


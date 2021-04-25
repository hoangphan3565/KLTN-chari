import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';
import { SupportedPeople } from '../models/SupportedPeople';

@Injectable({providedIn: 'root'})
export class SupportedPeopleService {  
  constructor( 
    private http: HttpClient){ }

  public getSupportedPeoples = async () => {
    try {
        const SupportedPeoples = await this.http.get(Api.baseUrl+Api.supportedPeoples);
        return await SupportedPeoples.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  saveSupportedPeople = async (SupportedPeople: SupportedPeople) => {
    try {
        const SupportedPeoples = await this.http.post(Api.baseUrl+Api.supportedPeoples,SupportedPeople);
        return await SupportedPeoples.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public deleteSupportedPeople = async (id: Number) => {
    try {
        const SupportedPeoples = await this.http.delete(Api.baseUrl+Api.supportedPeoples+'/'+id);
        return await SupportedPeoples.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


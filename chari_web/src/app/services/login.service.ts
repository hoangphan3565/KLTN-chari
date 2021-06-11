import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class LoginService {  
  constructor( 
    private http: HttpClient){ }

  public login = async (username,password) => {
    const data = {username,password};
    try {
        const user = await this.http.post(Api.baseUrl+Api.login,data) as any;
        return await user.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { User } from '../models/User';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class UserService {  
  constructor( 
    private http: HttpClient){ }

  public getUsers = async () => {
    try {
        const Users = await this.http.get(Api.baseUrl+Api.users);
        return await Users.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  public blockUser = async (id:Number) => {
    try {
        const Users = await this.http.delete(Api.baseUrl+Api.users+'/'+id);
        return await Users.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  public unblockUser = async (id:Number) => {
    try {
        const Users = await this.http.put(Api.baseUrl+Api.users+'/'+id,null);
        return await Users.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


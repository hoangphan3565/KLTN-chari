import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class AuthService {  
  constructor(){ }
  public login = (username,password) => {
    const data = {username,password};
    return Api.post(Api.url.login,data);
  }
}


import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class UserService {  
  constructor(){ }
  public getUsers = () => Api.get(Api.url.users);
  public blockUser = id => Api.delete(`${Api.url.users}/${id}`);
  public unblockUser = id => Api.put(`${Api.url.users}/${id}`);

  public countTotal = () => Api.get(`${Api.url.users}/count`);
  public getPerPage = (a,b) => Api.get(`${Api.url.users}/page/${a}/size/${b}`);
}


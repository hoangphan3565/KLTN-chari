import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class SupportedPeopleService {  
  constructor(){ }
  public countTotal = () => Api.get(`${Api.url.supportedPeoples}/count`);
  public getAll = () => Api.get(`${Api.url.supportedPeoples}`);
  public getSupportedPeoples = (a,b) => Api.get(`${Api.url.supportedPeoples}/page/${a}/size/${b}`);
  public saveSupportedPeople = (data,clb_id) => Api.post(`${Api.url.supportedPeoples}/collaborator/${clb_id}`,data);
  public deleteSupportedPeople = (id) => Api.delete(`${Api.url.supportedPeoples}/${id}`);
}


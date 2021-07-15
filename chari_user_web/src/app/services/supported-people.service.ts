import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class SupportedPeopleService {  
  constructor(){ }
  public getAll = clb_id => Api.get(`${Api.url.supportedPeoples}/collaborator/${clb_id}`);
  public countTotal = clb_id => Api.get(`${Api.url.supportedPeoples}/collaborator/${clb_id}/count`);
  public getSupportedPeoples = (clb_id,a,b) => Api.get(`${Api.url.supportedPeoples}/collaborator/${clb_id}/page/${a}/size/${b}`);
  public saveSupportedPeople = (data,clb_id) => Api.post(`${Api.url.supportedPeoples}/collaborator/${clb_id}`,data);
  public deleteSupportedPeople = (id,clb_id) => Api.delete(`${Api.url.supportedPeoples}/${id}/collaborator/${clb_id}`);
}


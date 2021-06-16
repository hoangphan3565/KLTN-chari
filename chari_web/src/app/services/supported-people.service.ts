import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class SupportedPeopleService {  
  constructor(){ }
  public getSupportedPeoples = () => Api.get(Api.url.supportedPeoples);
  public saveSupportedPeople = data => Api.post(Api.url.supportedPeoples,data);
  public deleteSupportedPeople = id => Api.delete(`${Api.url.supportedPeoples}/${id}`);
}


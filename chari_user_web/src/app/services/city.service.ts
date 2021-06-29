import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class CityService {  
  constructor(){ }
  public getCities = () => Api.get(Api.url.cities);
}


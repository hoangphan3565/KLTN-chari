import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectTypeService {  
  constructor(){ }
  public getProjectTypes = () => Api.get(Api.url.projectTypes);
  public countTotal = () => Api.get(`${Api.url.projectTypes}/count`);
  public getPerPage = (a,b) => Api.get(`${Api.url.projectTypes}/page/${a}/size/${b}`);
  public saveProjectType = data => Api.post(Api.url.projectTypes,data);
  public deleteProjectType = id => Api.delete(`${Api.url.projectTypes}/${id}`);
}


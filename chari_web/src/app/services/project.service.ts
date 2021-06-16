import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectService {  
  constructor(){ }
  public getProjects = () => Api.get(Api.url.projects+'/verified');
  public getUnverified = () => Api.get(Api.url.projects+'/unverified');
  public getActivating = () => Api.get(Api.url.projects+'/activating'); 
  public getReached = () => Api.get(Api.url.projects+'/reached'); 
  public getOverdue = () => Api.get(Api.url.projects+'/overdue');
  public getClosed = () => Api.get(Api.url.projects+'/closed');
  public updateMoveMoneyProgress = () => Api.put(`${Api.url.projects}/handle_all_money`);
  public createProject = (data,id) => Api.post(`${Api.url.projects}/create/collaborator/${id}`,data);
  public updateProject = (data) => Api.put(`${Api.url.projects}/update`,data);
  public deleteProject = id => Api.delete(`${Api.url.projects}/${id}`);
  public approveProject = id => Api.put(`${Api.url.projects}/approve/${id}`);
  public closeProject = (id,clb_id) => Api.put(`${Api.url.projects}/close/${id}/collaborator/${clb_id}`);
  public extendProject = (id,nod,clb_id) => Api.put(`${Api.url.projects}/extend/${id}/num_of_date/${nod}/collaborator/${clb_id}`);

}


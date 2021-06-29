import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectService {  
  constructor(){ }
  public getAllProjects = id => Api.get(`${Api.url.projects}/collaborator/${id}`);
  public getUncloseProjects = (id,a,b) => Api.get(`${Api.url.projects}/collaborator/${id}/from/${a}/to/${b}`);
  public countUncloseProjects = id => Api.get(`${Api.url.projects}/collaborator/${id}/count`);

  public getActivating = id => Api.get(Api.url.projects+'/activating/collaborator/'+id); 
  public getReached = id => Api.get(Api.url.projects+'/reached/collaborator/'+id); 
  public getOverdue = id => Api.get(Api.url.projects+'/overdue/collaborator/'+id);
  public getClosed = id => Api.get(Api.url.projects+'/closed/collaborator/'+id);
  public updateMoveMoneyProgress = () => Api.put(`${Api.url.projects}/handle_all_money`);
  public createProject = (data,id) => Api.post(`${Api.url.projects}/create/collaborator/${id}`,data);
  public updateProject = (data,id) => Api.put(`${Api.url.projects}/update/collaborator/${id}`,data);
  public deleteProject = id => Api.delete(`${Api.url.projects}/${id}`);
  public closeProject = (id,clb_id) => Api.put(`${Api.url.projects}/close/${id}/collaborator/${clb_id}`);
  public extendProject = (id,nod,clb_id) => Api.put(`${Api.url.projects}/extend/${id}/num_of_date/${nod}/collaborator/${clb_id}`);
}


import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectService {  
  constructor(){ }
  public getAllProjects = clb_id => Api.get(`${Api.url.projects}/collaborator/${clb_id}`);
  public getUncloseProjects = (clb_id,a,b) => Api.get(`${Api.url.projects}/collaborator/${clb_id}/page/${a}/size/${b}`);
  public countUncloseProjects = clb_id => Api.get(`${Api.url.projects}/collaborator/${clb_id}/count`);

  public coutClosed = clb_id => Api.get(`${Api.url.projects}/closed/collaborator/${clb_id}/count`);
  public getClosed = (clb_id,a,b) => Api.get(`${Api.url.projects}/closed/collaborator/${clb_id}/page/${a}/size/${b}`);

  public countActivating = (clb_id) => Api.get(`${Api.url.projects}/activating/collaborator/${clb_id}/count`);
  public getActivating = (clb_id,a,b) => Api.get(`${Api.url.projects}/activating/collaborator/${clb_id}/page/${a}/size/${b}`);

  public countReached = (clb_id) => Api.get(`${Api.url.projects}/reached/collaborator/${clb_id}/count`);
  public getReached = (clb_id,a,b) => Api.get(`${Api.url.projects}/reached/collaborator/${clb_id}/page/${a}/size/${b}`);

  public countOverdue = (clb_id) => Api.get(`${Api.url.projects}/overdue/collaborator/${clb_id}/count`);
  public getOverdue = (clb_id,a,b) => Api.get(`${Api.url.projects}/overdue/collaborator/${clb_id}/page/${a}/size/${b}`);

  public updateMoveMoneyProgress = () => Api.put(`${Api.url.projects}/handle_all_money`);
  public createProject = (data,clb_id) => Api.post(`${Api.url.projects}/create/collaborator/${clb_id}`,data);
  public updateProject = (data) => Api.put(`${Api.url.projects}/update`,data);
  public deleteProject = (id,clb_id) => Api.delete(`${Api.url.projects}/${id}/collaborator/${clb_id}`);
  public closeProject = (id,clb_id) => Api.put(`${Api.url.projects}/close/${id}/collaborator/${clb_id}`);
  public extendProject = (id,nod) => Api.put(`${Api.url.projects}/extend/${id}/num_of_date/${nod}`);
}


import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectService {  
  constructor(){ }
  public getProjects = ()=> Api.get(Api.url.projects);
  public getVerifiedProjects = (a,b) => Api.get(`${Api.url.projects}/page/${a}/size/${b}`);
  public countVerifiedProjects = () => Api.get(Api.url.projects+'/count');
 
  public getUnverified = (a,b) => Api.get(`${Api.url.projects}/unverified/page/${a}/size/${b}`);
  public countUnverifiedProjects = () => Api.get(Api.url.projects+'/unverified/count');
 
  public getClosed = (a,b) => Api.get(`${Api.url.projects}/closed/page/${a}/size/${b}`);
  public countClosedProjects = () => Api.get(Api.url.projects+'/closed/count');
  
  public getActivating = () => Api.get(Api.url.projects+'/activating'); 
  public getActivatingProjects = (a,b) => Api.get(`${Api.url.projects}/activating/page/${a}/size/${b}`);
  public countActivatingProjects = () => Api.get(Api.url.projects+'/activating/count');
 
  public getReached = () => Api.get(Api.url.projects+'/reached'); 
  public countReachedProjects = () => Api.get(Api.url.projects+'/reached/count');
 
  public getOverdue = () => Api.get(Api.url.projects+'/overdue');
  public countOverdueProjects = () => Api.get(Api.url.projects+'/overdue/count');
 

 
  public updateMoveMoneyProgress = () => Api.put(`${Api.url.projects}/handle_all_money`);
  public createProject = (data,id) => Api.post(`${Api.url.projects}/create/collaborator/${id}`,data);
  public updateProject = (data,id) => Api.put(`${Api.url.projects}/update/collaborator/${id}`,data);
  public updateAndApproveProject = (data) => Api.put(`${Api.url.projects}/update_and_approve`,data);
  public deleteProject = (id,clb_id) => Api.delete(`${Api.url.projects}/${id}/collaborator/${clb_id}`);
  public approveProject = id => Api.put(`${Api.url.projects}/approve/${id}`);
  public closeProject = (id,clb_id) => Api.put(`${Api.url.projects}/close/${id}/collaborator/${clb_id}`);
  public extendProject = (id,nod,clb_id) => Api.put(`${Api.url.projects}/extend/${id}/num_of_date/${nod}/collaborator/${clb_id}`);

}


import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectService {  
  constructor(){ }

  public getProjects = ()=> Api.get(Api.url.projects);
  public countVerifiedProjects = () => Api.get(Api.url.projects+'/count');
  public getVerifiedProjects = (a,b) => Api.get(`${Api.url.projects}/page/${a}/size/${b}`);
 
  public countUnverifiedProjects = () => Api.get(Api.url.projects+'/unverified/count');
  public getUnverified = (a,b) => Api.get(`${Api.url.projects}/unverified/page/${a}/size/${b}`);
 
  public countClosedProjects = () => Api.get(Api.url.projects+'/closed/count');
  public getClosed = (a,b) => Api.get(`${Api.url.projects}/closed/page/${a}/size/${b}`);
  
  public getAllActivating = () => Api.get(Api.url.projects+'/activating'); 
  public countActivatingProjects = () => Api.get(Api.url.projects+'/activating/count');
  public getActivatingProjects = (a,b) => Api.get(`${Api.url.projects}/activating/page/${a}/size/${b}`);
 
  public countReachedProjects = () => Api.get(Api.url.projects+'/reached/count'); 
  public getReachedProjects = (a,b) => Api.get(`${Api.url.projects}/reached/page/${a}/size/${b}`);
 
  public countOverdueProjects = () => Api.get(Api.url.projects+'/overdue/count');
  public getOverdueProjects = (a,b) => Api.get(`${Api.url.projects}/overdue/page/${a}/size/${b}`);
 
  public updateMoveMoneyProgress = () => Api.put(`${Api.url.projects}/handle_all_money`);
  public updateProjectStatus = () => Api.get(Api.url.projects+'/update_donate_status');

  public createProject = (data,id) => Api.post(`${Api.url.projects}/create/collaborator/${id}`,data);
  public updateProject = (data) => Api.put(`${Api.url.projects}/update`,data);
  public updateAndApproveProject = (data) => Api.put(`${Api.url.projects}/update_and_approve`,data);
  public deleteProject = (id) => Api.delete(`${Api.url.projects}/${id}`);
  public approveProject = id => Api.put(`${Api.url.projects}/approve/${id}`);
  public closeProject = (id) => Api.put(`${Api.url.projects}/close/${id}`);
  public extendProject = (id,nod) => Api.put(`${Api.url.projects}/extend/${id}/num_of_date/${nod}`);


  public countTotalMoney = () => Api.get(Api.url.projects+'/count_money');
  public disburseFund = () => Api.get(Api.url.projects+'/disburse_fund');

}


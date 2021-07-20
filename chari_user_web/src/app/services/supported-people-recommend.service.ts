import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class SupportedPeopleRecommendService {
  constructor(){ }
  public sendInfo = (data) => Api.post(`${Api.url.supportedPeopleRecommends}`,data);
  public getAll = () => Api.get(`${Api.url.supportedPeopleRecommends}`);
  public countAll = () => Api.get(`${Api.url.supportedPeopleRecommends}/count`);
  public getFromAtoB = (a,b) => Api.get(`${Api.url.supportedPeopleRecommends}/page/${a}/size/${b}`);
  public checkStatus = (id,clb_id) => Api.get(`${Api.url.supportedPeopleRecommends}/check/${id}/collaborator/${clb_id}`);
  public unHandle = id => Api.post(`${Api.url.supportedPeopleRecommends}/un_handle/${id}`);
  public save = data => Api.post(`${Api.url.supportedPeopleRecommends}`,data);
  public createProject = data => Api.post(`${Api.url.supportedPeopleRecommends}/create_project`,data);
  public saveDraft1 = data => Api.post(`${Api.url.supportedPeopleRecommends}/save_draft_step1`,data);
  public saveDraft2 = data => Api.post(`${Api.url.supportedPeopleRecommends}/save_draft_step2`,data);
  public delete = id => Api.delete(`${Api.url.supportedPeopleRecommends}/${id}`);
}


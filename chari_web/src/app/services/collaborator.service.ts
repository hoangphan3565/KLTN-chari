import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class CollaboratorService {  
  constructor(){ }
  public getCollaborators = () => Api.get(Api.url.collaborators);

  public countTotal = () => Api.get(`${Api.url.collaborators}/count`);
  public getPerPage = (a,b) => Api.get(`${Api.url.collaborators}/page/${a}/size/${b}`);

  public accept = id => Api.put(`${Api.url.collaborators}/accept/${id}`);
  public block = id => Api.put(`${Api.url.collaborators}/block/${id}`);
  public deleteCollaborator = id => Api.delete(`${Api.url.collaborators}/${id}`);
}


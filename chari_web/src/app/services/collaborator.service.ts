import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class CollaboratorService {  
  constructor(){ }
  public getCollaborators = () => Api.get(Api.url.collaborators);
  public accept = id => Api.put(`${Api.url.collaborators}/accept/${id}`);
  public block = id => Api.put(`${Api.url.collaborators}/block/${id}`);
  public deleteCollaborator = id => Api.delete(`${Api.url.collaborators}/${id}`);
}


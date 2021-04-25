import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { Collaborator } from '../models/Collaborator';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class CollaboratorService {  
  constructor( 
    private http: HttpClient){ }

  public getCollaborators = async () => {
    try {
        const Collaborators = await this.http.get(Api.baseUrl+Api.collaborators);
        return await Collaborators.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  saveCollaborator = async (Collaborator: Collaborator) => {
    try {
        const Collaborators = await this.http.post(Api.baseUrl+Api.collaborators,Collaborator);
        return await Collaborators.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
  public deleteCollaborator = async (id: Number) => {
    try {
        const Collaborators = await this.http.delete(Api.baseUrl+Api.collaborators+'/'+id);
        return await Collaborators.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


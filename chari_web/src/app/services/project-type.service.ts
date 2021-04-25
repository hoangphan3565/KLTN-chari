import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { ProjectType } from '../models/ProjectType';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectTypeService {  
  constructor( 
    private http: HttpClient){ }

  public getProjectTypes = async () => {
    try {
        const ProjectTypes = await this.http.get(Api.baseUrl+Api.projectTypes);
        return await ProjectTypes.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  saveProjectType = async (projectType: ProjectType) => {
    try {
        const ProjectTypes = await this.http.post(Api.baseUrl+Api.projectTypes,projectType);
        return await ProjectTypes.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public deleteProjectType = async (id: Number) => {
    try {
        const ProjectTypes = await this.http.delete(Api.baseUrl+Api.projectTypes+'/'+id);
        return await ProjectTypes.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


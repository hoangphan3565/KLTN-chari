import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { Project } from '../models/Project';
import { ProjectDTO } from '../models/ProjectDTO';
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class ProjectService {  
  constructor( 
    private http: HttpClient){ }

  public getProjects = async () => {
    try {
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/plain');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }    
  public getProjectDTOs = async () => {
    try {
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/dto_for_admin');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }  

  public getUnverified = async () => {
    try {
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/plain-unverified');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  } 

  public  createProject = async (ProjectDTO: ProjectDTO,isAdmin: boolean) => {
    try {
        const Projects = await this.http.post(Api.baseUrl+Api.projects+'/create/is_admin/'+isAdmin,ProjectDTO);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  saveProject = async (Project: Project) => {
    try {
        const Projects = await this.http.post(Api.baseUrl+Api.projects,Project);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
  
  public deleteProject = async (id: Number) => {
    try {
        const Projects = await this.http.delete(Api.baseUrl+Api.projects+'/'+id);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  } 
  public approveProject = async (id: Number) => {
    try {
        const Projects = await this.http.put(Api.baseUrl+Api.projects+'/approve/'+id,null);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


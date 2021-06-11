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
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/verified');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }    

  public getUnverified = async () => {
    try {
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/unverified');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  } 

  public getActivating = async () => {
    try {
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/activating');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  } 
  public getReached = async () => {
    try {
        const Projects = await this.http.get(Api.baseUrl+Api.projects+'/reached');
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }   
  public getOverdue = async () => {
    try {
      const Projects = await this.http.get(Api.baseUrl+Api.projects+'/overdue');
      return await Projects.toPromise();
    }
    catch (error) {
      console.log(error);
    }  
  }  

  public getClosed = async () => {
    try {
      const Projects = await this.http.get(Api.baseUrl+Api.projects+'/closed');
      return await Projects.toPromise();
    }
    catch (error) {
      console.log(error);
    }  
  }   

  public updateMoveMoneyProgress = async () => {
    try {
      const Projects = await this.http.put(Api.baseUrl+Api.projects+'/handle_all_money',null);
      return await Projects.toPromise();
    }
    catch (error) {
      console.log(error);
    }  
  } 

  public createProject = async (ProjectDTO: ProjectDTO,isAdmin: boolean) => {
    try {
        const Projects = await this.http.post(Api.baseUrl+Api.projects+'/create/is_admin/'+isAdmin,ProjectDTO);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public updateProject = async (Project: Project) => {
    try {
        const Projects = await this.http.put(Api.baseUrl+Api.projects+'/update',Project);
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
  public closeProject = async (id: Number) => {
    try {
        const Projects = await this.http.put(Api.baseUrl+Api.projects+'/close/'+id,null);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public extendProject = async (id: Number,nod:Number) => {
    try {
        const Projects = await this.http.put(Api.baseUrl+Api.projects+'/extend/'+id+'/num_of_date/'+nod,null);
        return await Projects.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}

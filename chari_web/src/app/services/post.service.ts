import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class PostService {  
  constructor(){ }
  public getPosts = (a,b) => Api.get(`${Api.url.posts}/page/${a}/size/${b}`);
  public countPost = () => Api.get(`${Api.url.posts}/count`);
  public savePost = (data,clb_id) => Api.post(`${Api.url.posts}/collaborator/${clb_id}`,data);
  public publicPost = (id,clb_id) => Api.put(`${Api.url.posts}/public/${id}/collaborator/${clb_id}`);
  public unPublicPost = (id,clb_id) => Api.put(`${Api.url.posts}/un_public/${id}/collaborator/${clb_id}`);
  public deletePost = (id,clb_id) => Api.delete(`${Api.url.posts}/${id}/collaborator/${clb_id}`);
}


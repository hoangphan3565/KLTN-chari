import { Injectable } from '@angular/core';
import { Api } from './api.service';

@Injectable({providedIn: 'root'})
export class PostService {  
  constructor(){ }
  public getAllPosts = id => Api.get(`${Api.url.posts}/collaborator/${id}`);
  public getPosts = (id,a,b) => Api.get(`${Api.url.posts}/collaborator/${id}/from/${a}/to/${b}`);
  public countPosts = id => Api.get(`${Api.url.posts}/collaborator/${id}/count`);
  public savePost = data => Api.post(Api.url.posts,data);
  public publicPost = id => Api.put(`${Api.url.posts}/public/${id}`);
  public unPublicPost = id => Api.put(`${Api.url.posts}/un_public/${id}`);
  public deletePost = id => Api.put(`${Api.url.posts}/${id}`);
}

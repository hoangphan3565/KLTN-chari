import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Api } from './api.service';
import { Post } from '../models/Post';

@Injectable({providedIn: 'root'})
export class PostService {  
  constructor( 
    private http: HttpClient){ }

  public getPosts = async () => {
    try {
        const Posts = await this.http.get(Api.baseUrl+Api.posts);
        return await Posts.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  savePost = async (Post: Post) => {
    try {
        const Posts = await this.http.post(Api.baseUrl+Api.posts,Post);
        return await Posts.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  publicPost = async (id: number) => {
    try {
        const Posts = await this.http.put(Api.baseUrl+Api.posts+'/public/'+id,null);
        return await Posts.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public  unPublicPost = async (id: number) => {
    try {
        const Posts = await this.http.put(Api.baseUrl+Api.posts+'/un_public/'+id,null);
        return await Posts.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }

  public deletePost = async (id: Number) => {
    try {
        const Posts = await this.http.delete(Api.baseUrl+Api.posts+'/'+id);
        return await Posts.toPromise();
    }
    catch (error) {
       console.log(error);
    }  
  }
}


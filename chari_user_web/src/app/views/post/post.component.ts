import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AngularFireStorage } from "@angular/fire/storage";
import { Post } from '../../models/Post';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import Cookies from 'js-cookie'


@Component({
  templateUrl: './post.component.html',
})
export class PostComponent implements OnInit {

  
  Posts: Post[];
  Post: Post;
  clb_id: Number;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;

  
  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getPosts(this.currentPage,this.itemsPerPage);

  }
  rowsChanged(event: any): void {
    this.itemsPerPage =  event.value;
    this.getPosts(this.currentPage,this.itemsPerPage);
  }

  constructor(
    private PostService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog,) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.initData();
  }

  initData(){
    this.getTotalPost();
    this.getPosts(1,this.itemsPerPage);
  }
  
  public async getTotalPost(){
    this.totalItems = await (await this.PostService.countPosts(this.clb_id)).data;
  }

  public async getPosts(a,b){
    this.Posts = await (await this.PostService.getPosts(this.clb_id,a,b)).data as Post[];
  }


  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPostComponent, {
      width: '900px',
      data: this.Post,
    });
    dialogRef.afterClosed().subscribe((res: Post) => {
      if(res){
        this.savePost(res);
      }
    });
  }
  openEditDialog(p : Post): void {
    this.Post = {
      pos_ID: p.pos_ID,
      name: p.name,
      content: p.content,
      projectId:p.projectId,
      projectName:p.projectName,
      isPublic: p.isPublic,
      imageUrl: p.imageUrl,
      videoUrl: p.videoUrl,
      collaboratorId:p.collaboratorId,
      images:p.images
    }; 
    this.openDialog();
  }
  clearData(){
    this.Post = {
      pos_ID: null,
      name: '',
      content: '',
      projectId:null,
      projectName:'',
      isPublic: true,
      imageUrl: '',
      videoUrl: '',
      collaboratorId:this.clb_id,
      images:[]
    };
  }

  public savePost = async (data) => {
    try 
    {
      const res = await (await this.PostService.savePost(data,this.clb_id)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getTotalPost();
        this.getPosts(1,this.itemsPerPage);
      }    
    }
    catch (e) {
      console.log(e);
    }
  };  



  public deletePost = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá tin tức này?')){
        const res = await (await this.PostService.deletePost(id,this.clb_id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getPosts(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

  public unPublicPost = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn ẩn tin này?')){
        const res = await (await this.PostService.unPublicPost(id,this.clb_id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getPosts(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
  public publicPost = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn hiện tin này?')){
        const res = await (await this.PostService.publicPost(id,this.clb_id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getPosts(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}


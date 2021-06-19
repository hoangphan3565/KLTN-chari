import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AngularFireStorage } from "@angular/fire/storage";
import { Post } from '../../models/Post';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { DialogPostComponent } from './dialog-post/dialog-post.component';


@Component({
  templateUrl: './post.component.html',
})
export class PostComponent implements OnInit {

  
  Posts: Post[];
  Post: Post;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getPost((this.currentPage-1)*this.itemsPerPage,this.currentPage*this.itemsPerPage);

  }

  constructor(
    private PostService: PostService,
    private notificationService: NotificationService,
    private storage: AngularFireStorage,
    public dialog: MatDialog,) { }

  ngOnInit(): void {
    this.getTotalPost();
    this.getPost(0,this.itemsPerPage);
  }

  public async getTotalPost(){
    this.totalItems = await (await this.PostService.countPost()).data;
  }

  public async getPost(a,b){
    this.Posts = await (await this.PostService.getPosts(a,b)).data as Post[];
  }


  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPostComponent, {
      width: '900px',
      data: this.Post,
    });
    dialogRef.afterClosed().subscribe((result: Post) => {
      if(result){
        if (result.pos_ID==null) this.savePost(result,'Thêm');
        else this.savePost(result,'Cập nhật');
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
      collaboratorId:0,
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
      isPublic: null,
      imageUrl: '',
      videoUrl: '',
      collaboratorId:0,
      images:[]
    };
  }

  public savePost = async (data,state) => {
    try 
    {
      const result = await this.PostService.savePost(data);
      if (result)
      {
        this.notificationService.success(state+' tin tức thành công');
        this.Posts = result.data as Post[];
      }    
    }
    catch (e) {
      alert(state+' tin tức thất bại');
    }
  };  



  public deletePost = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá tin tức này?')){
        const result = await this.PostService.deletePost(id);
        if (result)
        {
          this.notificationService.warn('Xoá tin tức thành công');
          this.Posts = result.data as Post[];
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
      if(confirm('Bạn có thực sự muốn hủy công bố tin tức này?')){
        const result = await this.PostService.unPublicPost(id);
        if (result)
        {
          this.notificationService.warn('Huỷ công bố tin tức thành công');
          this.Posts = result.data as Post[];
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
      if(confirm('Bạn có thực sự muốn công bố tin tức này?')){
        const result = await this.PostService.publicPost(id);
        if (result)
        {
          this.notificationService.warn('Công bố tin tức thành công');
          this.Posts = result.data as Post[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}


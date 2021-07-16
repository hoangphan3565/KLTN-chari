import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { SupportedPeople } from '../../models/SupportedPeople';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import Cookies from 'js-cookie'
import { DialogPostComponent } from './dialog-post/dialog-post.component';


@Component({
  templateUrl: './project-reached.component.html',
})
export class ProjectReachedComponent implements OnInit {
  Post: Post;
  Projects: Project[];
  clb_id: Number;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getList(this.currentPage,this.itemsPerPage);
  }
  rowsChanged(event: any): void {
    this.itemsPerPage =  event.value;
    this.getList(this.currentPage,this.itemsPerPage);
  }

  constructor(
    private projectService: ProjectService,
    private postService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.countTotal();
    this.getList(1,this.itemsPerPage);
  }

  public async countTotal(){
    this.totalItems = await (await this.projectService.countReached(this.clb_id)).data;
  }

  public async getList(a,b){
    this.Projects = await (await this.projectService.getReached(this.clb_id,a,b)).data as Project[];
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

  clearData(p:Project){
    this.Post = {
      pos_ID: null,
      name: '',
      content: '',
      projectId:p.prj_ID,
      projectName:p.projectName,
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
      const res = await this.postService.savePost(data,this.clb_id);
      if (res)
      {
        this.notificationService.success('Thêm tin tức thành công');
      }    
    }
    catch (e) {
      alert('Thêm tin tức thất bại');
    }
  }
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }
}


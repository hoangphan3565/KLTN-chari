import { Component, OnInit,Pipe } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
@Component({
  templateUrl: './project-activating.component.html',
})
export class ProjectActivatingComponent implements OnInit {
  Projects: Project[];
  Post: Post;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getActivating((this.currentPage-1)*this.itemsPerPage,this.currentPage*this.itemsPerPage);
  }

  constructor(
    private projectService: ProjectService,
    private postService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getAllActivating()
  }
  public async getAllActivating(){
    this.Projects = await (await this.projectService.getActivating()).data as Project[];
  }  
  public async getActivating(a,b){
    this.Projects = await (await this.projectService.getActivatingProjects(a,b)).data as Project[];
  }
  

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPostComponent, {
      width: '900px',
      data: this.Post,
    });
    dialogRef.afterClosed().subscribe((result: Post) => {
      if(result){
        this.savePost(result);
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
      isPublic: null,
      imageUrl: '',
      videoUrl: '',
      collaboratorId:0,
      images:[]
    };
  }

  public savePost = async (data) => {
    try 
    {
      const result = await this.postService.savePost(data);
      if (result)
      {
        this.notificationService.success('Thêm tin tức thành công');
      }    
    }
    catch (e) {
      alert('Thêm tin tức thất bại');
    }
  };  
}

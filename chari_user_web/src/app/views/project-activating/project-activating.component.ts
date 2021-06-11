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

  constructor(
    private projectService: ProjectService,
    private postService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getActivating()
  }
  public async getActivating(){
    this.Projects = await this.projectService.getActivating() as Project[];
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

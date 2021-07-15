import { Component, OnInit,Pipe } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
import Cookies from 'js-cookie'
import { DialogDonateInfoComponent } from './dialog-donateinfo-project/dialog-donateinfo-project.component';

@Component({
  templateUrl: './project-activating.component.html',
})
export class ProjectActivatingComponent implements OnInit {
  Projects: Project[];
  Post: Post;
  clb_id: Number;

  constructor(
    private projectService: ProjectService,
    private postService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.getActivating()
  }
  public async getActivating(){
    this.Projects = await (await this.projectService.getActivating(this.clb_id)).data as Project[];
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

  openDonateInfoDialog(data): void {
    const dialogRef = this.dialog.open(DialogDonateInfoComponent, {
      width: '350px',
      data: data
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
  };  
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }
}

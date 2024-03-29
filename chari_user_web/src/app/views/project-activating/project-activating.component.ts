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

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getList(this.currentPage,this.itemsPerPage);
  }

  public options = [
    {"id": 1, "value": 5},
    {"id": 2, "value": 10},
    {"id": 3, "value": 25},
    {"id": 4, "value": 100},
  ]
  public selected1 = this.options[0].id;

  rowsChanged(event: any): void {
    this.itemsPerPage = this.options[event.value-1].value;
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
    this.totalItems = await (await this.projectService.countActivating(this.clb_id)).data;
  }

  public async getList(a,b){
    this.Projects = await (await this.projectService.getActivating(this.clb_id,a,b)).data as Project[];
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

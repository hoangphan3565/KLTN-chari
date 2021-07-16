import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import { DialogPostReachedComponent } from './dialog-post/dialog-post.component';
import * as XLSX from 'xlsx';
import { DonateDetailsService } from '../../services/donate-details.service';
import { DonateDetail } from '../../models/DonateDetail';

@Component({
  templateUrl: './project-reached.component.html',
})
export class ProjectReachedComponent implements OnInit {
  Post: Post;
  Projects: Project[];
  data: [][];
  DonateDetail: DonateDetail;

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
    private DonateDetailsService: DonateDetailsService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.countTotal();
    this.getList(1,this.itemsPerPage);
  }


  public async countTotal(){
    this.totalItems = await (await this.projectService.countReachedProjects()).data;
  }

  public async getList(a,b){
    this.Projects = await (await this.projectService.getReachedProjects(a,b)).data as Project[];
  } 
  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    });
  }
  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPostReachedComponent, {
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
      collaboratorId:0,
      images:[]
    };
  }

  public savePost = async (data) => {
    try 
    {
      const res = await this.postService.savePost(data,0);
      if (res)
      {
        this.notificationService.success('Thêm tin tức thành công');
      }    
    }
    catch (e) {
      alert('Thêm tin tức thất bại');
    }
  }
  
  onFileChange(ev) {
    let workBook = null;
    let jsonData = null;
    const reader = new FileReader();
    const file = ev.target.files[0];
    reader.onload = (event) => {
      const data = reader.result;
      workBook = XLSX.read(data, { type: 'binary' });
      jsonData = workBook.SheetNames.reduce((initial, name) => {
        const sheet = workBook.Sheets[name];
        initial[name] = XLSX.utils.sheet_to_json(sheet);
        return initial;
      }, {});
      this.disburseWithBank(jsonData.Sheet1 as DonateDetail[]);
    }
    reader.readAsBinaryString(file);
  }

  public disburseWithBank = async (data: any[]) => {
    try 
    {
      const res = await (await this.DonateDetailsService.disburseWithBank(data)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getList(this.currentPage,this.itemsPerPage);
      }
    }
    catch (e) {
      alert('Cập nhật giải ngân từ bảng sao kê thất bại');
    }
  };
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  };
}


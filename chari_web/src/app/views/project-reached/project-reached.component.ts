import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { SupportedPeople } from '../../models/SupportedPeople';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import { DialogPostComponent } from './dialog-post/dialog-post.component';
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

  constructor(
    private ProjectService: ProjectService,
    private postService: PostService,
    private DonateDetailsService: DonateDetailsService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getReached()
  }
  public async getReached(){
    this.Projects = await this.ProjectService.getReached() as Project[];
  }

  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    });
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
  }
  
  onFileChange(evt: any) {
    const target : DataTransfer =  <DataTransfer>(evt.target);
    if (target.files.length !== 1) throw new Error('Cannot use multiple files');
    const reader: FileReader = new FileReader();
    reader.onload = (e: any) =>  {
      const bstr: string = e.target.result;
      var wb: XLSX.WorkBook = XLSX.read(bstr, { type: 'binary' });
      
      wb.SheetNames.forEach(sheet => {
        let rowObject = XLSX.utils.sheet_to_json(wb.Sheets[sheet]);
        console.log(rowObject);
        this.saveDonateWithBankDetail(rowObject);
      })
    };
  
    reader.readAsBinaryString(target.files[0]);
  }

  public saveDonateWithBankDetail = async (data: any[]) => {
    try 
    {
      const result = await this.DonateDetailsService.saveDonateWithBankDetail(data);
      if (result==1)
      {
        this.notificationService.success('Cập nhật tiền quyên góp từ bảng sao kê thành công');
      }    
    }
    catch (e) {
      alert('Cập nhật tiền quyên góp từ bảng sao kê thất bại');
    }
  };

}


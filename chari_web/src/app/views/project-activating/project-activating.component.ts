import { Component, OnInit,Pipe } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import { DialogPostActivatingComponent } from './dialog-post/dialog-post.component';
import * as XLSX from 'xlsx';
import { DonateDetailsService } from '../../services/donate-details.service';
import { DonateDetail } from '../../models/DonateDetail';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';

@Component({
  templateUrl: './project-activating.component.html',
})
export class ProjectActivatingComponent implements OnInit {
  Projects: Project[];
  Project: Project;
  Post: Post;

  data: [][];
  DonateDetail: DonateDetail;

  constructor(
    private DonateDetailsService: DonateDetailsService,
    private projectService: ProjectService,
    private postService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getAllActivating();
  }
  public async getAllActivating(){
    this.Projects = await (await this.projectService.getActivating()).data as Project[];
  }    

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPostActivatingComponent, {
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
  };  

  // onFileChange(evt: any) {
  //   const target : DataTransfer =  <DataTransfer>(evt.target);
  //   if (target.files.length !== 1) throw new Error('Cannot use multiple files');
  //   const reader: FileReader = new FileReader();
  //   reader.onload = (e: any) =>  {
  //     const bstr: string = e.target.res;
  //     var wb: XLSX.WorkBook = XLSX.read(bstr, { type: 'binary' });
      
  //     wb.SheetNames.forEach(sheet => {
  //       let rowObject = XLSX.utils.sheet_to_json(wb.Sheets[sheet]);
  //       console.log(rowObject);
  //       this.saveDonateWithBank(rowObject);
  //     })
  //   };
  
  //   reader.readAsBinaryString(target.files[0]);
  // }
  
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
      this.saveDonateWithBank(jsonData.Sheet1 as DonateDetail[]);
    }
    reader.readAsBinaryString(file);
  }

  public saveDonateWithBank = async (data: any[]) => {
    try 
    {
      const res = await (await this.DonateDetailsService.saveDonateWithBank(data)).data;
      if (res==1)
      {
        this.notificationService.success('Cập nhật tiền quyên góp từ bảng sao kê thành công');
        this.getAllActivating();
      }    
    }
    catch (e) {
      alert('Cập nhật tiền quyên góp từ bảng sao kê thất bại');
    }
  };
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  };

  //==============================================================================================================================


  openProjectDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectComponent, {
      width: '900px',
      data: this.Project,
    });
    dialogRef.afterClosed().subscribe((res) => {
      if(res){
        if (res.prj_ID==null) this.ceateProject(res);
        else this.updateProject(res);
      }
    });
  }
  openEditProjectDialog(p : Project): void {
    this.Project = {
      prj_ID:p.prj_ID,
      projectName:p.projectName,
      briefDescription:p.briefDescription,
      description:p.description,
      imageUrl:p.imageUrl,
      videoUrl:p.videoUrl,
      startDate:p.startDate,
      endDate:p.endDate,
      targetMoney:p.targetMoney,
      canDisburseWhenOverdue:p.projectType.canDisburseWhenOverdue,
      prt_ID:p.projectType.prt_ID,
      projectType:p.projectType,      
      cti_ID:p.city.cti_ID,
      city:p.city,
      stp_ID:p.supportedPeople.stp_ID,
      supportedPeople:p.supportedPeople,
      images:p.images
    }; 
    this.openProjectDialog();
  }
  openAddProjectDialog(){
    this.Project = {
      prj_ID:null,
      projectName:'',
      briefDescription:'',
      description:'',
      imageUrl:'',
      videoUrl:'',
      startDate:'',
      endDate:'',
      targetMoney:'',
      canDisburseWhenOverdue:true,
      prt_ID:null,
      projectType:null,      
      cti_ID:null,
      city:null,
      stp_ID:null,
      supportedPeople:null,
      images:[]
    };
    this.openProjectDialog();
  }

  public ceateProject = async (data) => {
    try 
    {
      const res = await this.projectService.createProject(data,0);
      if (res)
      {
        this.notificationService.success('Thêm dự án từ thiện thành công');
        // this.getVerifiedProjects(1,this.itemsPerPage);
        this.getAllActivating();

      }    
    }
    catch (e) {
      this.notificationService.warn('Thêm dự án từ thiện thất bại');
    }
  };  

  public updateProject = async (data) => {
    try 
    {
      const res = await (await this.projectService.updateProject(data,0)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        // this.getVerifiedProjects(this.currentPage,this.itemsPerPage);
        this.getAllActivating();

      }    
    }
    catch (e) {
      this.notificationService.warn('Cập nhật thất bại');
    }
  };
  
}

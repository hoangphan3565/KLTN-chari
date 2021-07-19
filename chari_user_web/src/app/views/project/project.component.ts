import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AngularFireStorage } from "@angular/fire/storage";
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';
import Cookies from 'js-cookie'



@Component({
  templateUrl: './project.component.html',
})
export class ProjectComponent implements OnInit {

  
  Projects: Project[];
  Project: Project;
  clb_id: Number;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;

  public options = [
    {"id": 1, "value": 5},
    {"id": 2, "value": 10},
    {"id": 3, "value": 25},
    {"id": 4, "value": 100},
  ]
  public selected1 = this.options[0].id;

  rowsChanged(event: any): void {
    this.itemsPerPage = this.options[event.value-1].value;
    this.getProjects(this.currentPage,this.itemsPerPage);
  }
  
  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getProjects(this.currentPage,this.itemsPerPage);

  }



  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    private storage: AngularFireStorage,
    public dialog: MatDialog,) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.getTotalUncloseProject();
    this.getProjects(1,this.itemsPerPage);
  }
  
  public async getTotalUncloseProject(){
    this.totalItems = await (await this.ProjectService.countUncloseProjects(this.clb_id)).data;

  }


  public async getProjects(a,b){
    this.Projects = await (await this.ProjectService.getUncloseProjects(this.clb_id,a,b)).data as Project[];
  }


  openDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectComponent, {
      width: '900px',
      data: this.Project,
    });
    dialogRef.afterClosed().subscribe((res: Project) => {
      if(res){
        if (res.prj_ID==null) this.ceateProject(res);
        else this.updateProject(res);
      }
    });
  }
  openEditDialog(p : Project): void {
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
      stp_ID:p.supportedPeople.stp_ID,
      supportedPeople:p.supportedPeople,
      cti_ID:p.city.cti_ID,
      city:p.city,
      images:p.images
    }; 
    this.openDialog();
  }
  clearData(){
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
      stp_ID:null,
      supportedPeople:null,      
      cti_ID:null,
      city:null,
      images:[]
    };
  }

  public ceateProject = async (data) => {
    try 
    {
      const res = await (await this.ProjectService.createProject(data, this.clb_id)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getProjects(1,this.itemsPerPage);
      }    
    }
    catch (e) {
      alert('Thêm dự án thất bại');
    }
  };  

  public updateProject = async (data) => {
    try 
    {
      const res = await (await this.ProjectService.updateProject(data)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getProjects(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      alert('Cập nhật thất bại');
    }
  };


  public deleteProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá dự án này?')){
        const res = await (await this.ProjectService.deleteProject(id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getProjects(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      alert('Xóa dự án thất bại');
    }
  }
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }
}


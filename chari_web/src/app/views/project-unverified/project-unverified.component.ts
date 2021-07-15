import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogApproveProjectComponent } from './dialog-approve-project/dialog-project.component';
@Component({
  templateUrl: './project-unverified.component.html',
})
export class ProjectUnverifiedComponent implements OnInit {
  Projects: Project[];
  Project: Project;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getUnverified(this.currentPage,this.itemsPerPage);
  }
  rowsChanged(event: any): void {
    this.itemsPerPage =  event.value;
    this.getUnverified(this.currentPage,this.itemsPerPage);
  }

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getTotaUnverified();
    this.getUnverified(1,this.itemsPerPage);
  }

  public async getTotaUnverified(){
    this.totalItems = await (await this.ProjectService.countUnverifiedProjects()).data;
  }
  async getUnverified(a,b){
    this.Projects = await (await this.ProjectService.getUnverified(a,b)).data as Project[];
  }


  public approveProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn duyệt dự án từ thiện này?')){
        const res = await (await this.ProjectService.approveProject(id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getTotaUnverified();
          this.getUnverified(this.currentPage,this.itemsPerPage);
        }
      }
    }
    catch (e) {
      console.log(e);
    }
  }
  public deleteProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá dự án này?')){
        const res = await (await this.ProjectService.deleteProject(id,0)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getUnverified(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }


  public updateAndApproveProject = async (data) => {
    try 
    {
      const res = await (await this.ProjectService.updateAndApproveProject(data)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getUnverified(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      this.notificationService.warn('Duyệt dự án thất bại');
    }
  };
  
 

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogApproveProjectComponent, {
      width: '900px',
      data: this.Project,
    });
    dialogRef.afterClosed().subscribe((res) => {
      if(res){
        if(res=='delete'){
          this.getUnverified(this.currentPage,this.itemsPerPage);
        }else{
          this.updateAndApproveProject(res);
        }
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
      cti_ID:p.city.cti_ID,
      city:p.city,
      stp_ID:p.supportedPeople.stp_ID,
      supportedPeople:p.supportedPeople,
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
      canDisburseWhenOverdue:null,
      prt_ID:null,
      projectType:null,      
      cti_ID:null,
      city:null,
      stp_ID:null,
      supportedPeople:null,
      images:[]
    };
  }
}


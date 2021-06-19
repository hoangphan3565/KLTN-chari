import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';
import { ViewEncapsulation  } from '@angular/core';


@Component({
  templateUrl: './project.component.html',
  styles: ['.pager li.btn:active { box-shadow: none; }'],
  encapsulation: ViewEncapsulation.None,
})
export class ProjectComponent implements OnInit {

  
  Projects: Project[];
  Project: Project;


  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getVerifiedProjects((this.currentPage-1)*this.itemsPerPage,this.currentPage*this.itemsPerPage);

  }

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog,) { }

  ngOnInit(): void {
    this.countVerifiedProjects();
    this.getVerifiedProjects(0,this.itemsPerPage);
  }

  public async countVerifiedProjects(){
    this.totalItems = await (await this.ProjectService.countVerifiedProjects()).data;
  }

  public async getVerifiedProjects(a,b){
    this.Projects = await (await this.ProjectService.getVerifiedProjects(a,b)).data as Project[];
  }


  openDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectComponent, {
      width: '900px',
      data: this.Project,
    });
    dialogRef.afterClosed().subscribe((result) => {
      if(result){
        if (result.prj_ID==null) this.ceateProject(result);
        else this.updateProject(result);
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
      images:[]
    };
  }

  public ceateProject = async (data) => {
    try 
    {
      const result = await this.ProjectService.createProject(data,0);
      if (result)
      {
        this.notificationService.success('Thêm dự án từ thiện thành công');
        this.Projects = result.data as Project[];
      }    
    }
    catch (e) {
      this.notificationService.warn('Thêm dự án từ thiện thất bại');
    }
  };  

  public updateProject = async (data) => {
    try 
    {
      const result = await this.ProjectService.updateProject(data);
      if (result)
      {
        this.notificationService.success('Cập nhật dự án thành công');
        this.Projects = result.data as Project[];
      }    
    }
    catch (e) {
      this.notificationService.warn('Cập nhật thất bại');
    }
  };
}


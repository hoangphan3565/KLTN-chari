import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AngularFireStorage } from "@angular/fire/storage";
import { Project } from '../../models/Project';
import { ProjectDTO } from '../../models/ProjectDTO';
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


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getProjects((this.currentPage-1)*this.itemsPerPage,this.currentPage*this.itemsPerPage);

  }

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    private storage: AngularFireStorage,
    public dialog: MatDialog,) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.getTotalUncloseProject();
    this.getProjects(0,this.itemsPerPage);
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
    dialogRef.afterClosed().subscribe((result: ProjectDTO) => {
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
      const result = await this.ProjectService.createProject(data,this.clb_id);
      if (result)
      {
        this.notificationService.success('Thêm chương trình từ thiện thành công');
        this.Projects = result.data as Project[];
      }    
    }
    catch (e) {
      alert('Thêm chương trình từ thiện thất bại');
    }
  };  

  public updateProject = async (data) => {
    try 
    {
      const result = await this.ProjectService.updateProject(data);
      if (result)
      {
        this.notificationService.success('Cập nhật chương trình từ thiện thành công');
        this.Projects = result.data as Project[];
      }    
    }
    catch (e) {
      alert('Cập nhật chương trình từ thiện thất bại');
    }
  };


  public deleteProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá chương trình từ thiện này?')){
        const result = await this.ProjectService.deleteProject(id);
        if (result)
        {
          this.notificationService.warn('Xoá chương trình từ thiện thành công');
          this.Projects = result.data as Project[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}


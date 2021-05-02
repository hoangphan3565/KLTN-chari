import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { ProjectDTO } from '../../models/ProjectDTO';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';
@Component({
  templateUrl: './project.component.html',
})
export class ProjectComponent implements OnInit {
  Projects: Project[];
  Project: Project;

  ProjectDTOs: ProjectDTO[];
  ProjectDTO: ProjectDTO;

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getProject();
    this.getProjectDTO();
  }
  public async getProject(){
    this.Projects = await this.ProjectService.getProjects() as Project[];
  }

  public async getProjectDTO(){
    this.ProjectDTOs = await this.ProjectService.getProjectDTOs() as ProjectDTO[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectComponent, {
      width: '400px',
      data: this.ProjectDTO,
    });
    dialogRef.afterClosed().subscribe((result: ProjectDTO) => {
      if(result){
        if (result.prj_ID==null) this.ceateProject(result);
        else this.saveProject(result,'Cập nhật');
      }
    });
  }
  openEditDialog(p : Project): void {
    this.ProjectDTO = {
      prj_ID:p.prj_ID,
      projectName:p.projectName,
      briefDescription:p.briefDescription,
      description:p.description,
      imageUrl:p.imageUrl,
      videoUrl:p.videoUrl,
      startDate:p.startDate,
      endDate:p.endDate,
      targetMoney:p.targetMoney,
      prt_ID:p.projectType.prt_ID,
      stp_ID:p.supportedPeople.stp_ID,
      images:null
    }; 
    this.openDialog();
  }
  clearData(){
    this.ProjectDTO = {
      prj_ID:null,
      projectName:'',
      briefDescription:'',
      description:'',
      imageUrl:'',
      videoUrl:'',
      startDate:'',
      endDate:'',
      targetMoney:'',
      prt_ID:null,
      stp_ID:null,
      images:null
    };
  }

  public ceateProject = async (data) => {
    try 
    {
      const result = await this.ProjectService.createProject(data,true);
      if (result)
      {
        this.notificationService.success('Thêm chương trình từ thiện thành công');
        this.Projects = result as Project[];
      }    
    }
    catch (e) {
      alert('Thêm chương trình từ thiện thất bại');
    }
  };  

  public saveProject = async (data,state) => {
    try 
    {
      const result = await this.ProjectService.saveProject(data);
      if (result)
      {
        this.notificationService.success(state+' chương trình từ thiện thành công');
        this.Projects = result as Project[];
      }    
    }
    catch (e) {
      alert(state+' chương trình từ thiện thất bại');
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
          this.Projects = result as Project[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}


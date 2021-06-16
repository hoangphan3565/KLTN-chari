import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogExtendComponent } from './dialog-extend/dialog-extend.component';
import Cookies from 'js-cookie'

@Component({
  templateUrl: './project-overdue.component.html',
})
export class ProjectOverdueComponent implements OnInit {
  Projects: Project[];
  clb_id: Number;


  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.getOverdue()
  }
  public async getOverdue(){
    this.Projects = await (await this.ProjectService.getOverdue(this.clb_id)).data as Project[];
  }
  public closeProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự đóng dự án này?')){
        const result = await this.ProjectService.closeProject(id, this.clb_id);
        if (result)
        {
          this.notificationService.warn('Đóng dự án thành công');
          this.Projects = result.data as Project[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

  openExtendDialog(id): void {
    const dialogRef = this.dialog.open(DialogExtendComponent, {
      width: '250px',
      data: 30 
    });
    dialogRef.afterClosed().subscribe((result: Number) => {
      if(result){
        this.extendProject(id,result);
      }
    });
  }
  

  public extendProject = async (id,nod) => {
    try 
    {
      const result = await this.ProjectService.extendProject(id,nod,this.clb_id);
      if (result)
      {
        this.notificationService.warn('Gia hạn dự án thành công');
        this.Projects = result.data as any[];
      }  
    }
    catch (e) {
      console.log(e);
    }
  }
}


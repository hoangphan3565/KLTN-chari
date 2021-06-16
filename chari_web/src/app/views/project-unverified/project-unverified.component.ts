import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
@Component({
  templateUrl: './project-unverified.component.html',
})
export class ProjectUnverifiedComponent implements OnInit {
  Projects: Project[];
  Project: Project;

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getUnverified()
  }

  async getUnverified(){
    this.Projects = await (await this.ProjectService.getUnverified()).data as Project[];
  }

  public approveProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn duyệt chương trình từ thiện này?')){
        const result = await this.ProjectService.approveProject(id);
        if (result)
        {
          this.notificationService.warn('Phê duyệt thành công');
          this.Projects = result.data as Project[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}


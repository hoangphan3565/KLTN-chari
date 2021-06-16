import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import Cookies from 'js-cookie'


@Component({
  templateUrl: './project-closed.component.html',
})
export class ProjectClosedComponent implements OnInit {
  Projects: any[];
  clb_id: Number;

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.getClosed()
  }

  async getClosed(){
    this.Projects = await (await this.ProjectService.getClosed(this.clb_id)).data as any[];
  }

  async updateMoveMoneyProgress(){
    const result = await (await this.ProjectService.updateMoveMoneyProgress()).data as any[];
    if (result)
      {
        this.notificationService.success(' Cập nhật thành công');
        this.Projects = result as any[];
      }   
  }
}


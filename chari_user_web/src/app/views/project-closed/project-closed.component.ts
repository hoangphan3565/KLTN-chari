import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';


@Component({
  templateUrl: './project-closed.component.html',
})
export class ProjectClosedComponent implements OnInit {
  Projects: any[];

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getClosed()
  }

  async getClosed(){
    this.Projects = await this.ProjectService.getClosed() as any[];
  }

  async updateMoveMoneyProgress(){
    const result = await this.ProjectService.updateMoveMoneyProgress() as any[];
    if (result)
      {
        this.notificationService.success(' Cập nhật thành công');
        this.Projects = result as any[];
      }   
  }
  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    });
  }
}


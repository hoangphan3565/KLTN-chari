import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { SupportedPeople } from '../../models/SupportedPeople';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
@Component({
  templateUrl: './project-reached.component.html',
})
export class ProjectReachedComponent implements OnInit {

  Projects: any[];

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getReached()
  }
  public async getReached(){
    this.Projects = await this.ProjectService.getReached() as any[];
  }

  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    });
  }
  
}


import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
@Component({
  templateUrl: './project-Failed.component.html',
})
export class ProjectFailedComponent implements OnInit {
  Projects: Project[];
  Project: Project;

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getFailed()
  }
  public async getFailed(){
    // this.Projects = await this.ProjectService.getFailed() as Project[];
  }
}


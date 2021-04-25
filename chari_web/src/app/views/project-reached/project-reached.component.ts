import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
@Component({
  templateUrl: './project-reached.component.html',
})
export class ProjectReachedComponent implements OnInit {
  Projects: Project[];
  Project: Project;

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getReached()
  }
  public async getReached(){
    // this.Projects = await this.ProjectService.getReached() as Project[];
  }
}


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
  public async getUnverified(){
    this.Projects = await this.ProjectService.getUnverified() as Project[];
  }
}


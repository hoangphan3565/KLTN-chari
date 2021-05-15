import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
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
}


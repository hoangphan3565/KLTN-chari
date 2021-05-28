import { Component, OnInit,Pipe } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
@Component({
  templateUrl: './project-activating.component.html',
})
export class ProjectActivatingComponent implements OnInit {
  Projects: Project[];

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getActivating()
  }
  public async getActivating(){
    this.Projects = await this.ProjectService.getActivating() as Project[];
  }
}

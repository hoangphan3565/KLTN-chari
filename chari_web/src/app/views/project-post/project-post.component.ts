import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
@Component({
  templateUrl: './project-post.component.html',
})
export class ProjectPostComponent implements OnInit {


  constructor(
  ) { }

  ngOnInit(): void {
  }
}


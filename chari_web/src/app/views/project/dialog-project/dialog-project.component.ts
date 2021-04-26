import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { ProjectType } from '../../../models/ProjectType';
import { NotificationService } from '../../../services/notification.service';
import { Project } from '../../../models/Project';
import { SupportedPeople } from '../../../models/SupportedPeople';
import { SupportedPeopleService } from '../../../services/supported-people.service';
import { ProjectTypeService } from '../../../services/project-type.service';

@Component({
    selector: 'app-dialog-project',
    templateUrl: './dialog-project.component.html',
})
export class DialogProjectComponent implements OnInit {
  ProjectTypes: ProjectType[];
  SupportedPeoples: SupportedPeople[];

  constructor(
    private notificationService: NotificationService,
    private SupportedPeopleService: SupportedPeopleService,
    private projectTypeService: ProjectTypeService,
    public dialogRef: MatDialogRef<DialogProjectComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Project) { }

  ngOnInit(): void {
    this.getProjectType();
    this.getSupportedPeople();
  }  
  public async getProjectType(){
    this.ProjectTypes = await this.projectTypeService.getProjectTypes() as ProjectType[];
  }
  public async getSupportedPeople(){
    this.SupportedPeoples = await this.SupportedPeopleService.getSupportedPeoples() as SupportedPeople[];
  }
  save(){
    this.dialogRef.close(this.data);
  }
}
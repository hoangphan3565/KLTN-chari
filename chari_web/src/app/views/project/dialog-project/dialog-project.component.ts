import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { ProjectType } from '../../../models/ProjectType';
import { NotificationService } from '../../../services/notification.service';
import { Project } from '../../../models/Project';
import { SupportedPeople } from '../../../models/SupportedPeople';
import { SupportedPeopleService } from '../../../services/supported-people.service';
import { ProjectTypeService } from '../../../services/project-type.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { Observable } from 'rxjs';
import { map, finalize } from "rxjs/operators";

@Component({
    selector: 'app-dialog-project',
    templateUrl: './dialog-project.component.html',
    styleUrls: ['./dialog-project.component.css']
})
export class DialogProjectComponent implements OnInit {

  files: any = [];
  urls: any = [];
  fb;
  downloadURL: Observable<string>;
  ProjectTypes: ProjectType[];
  SupportedPeoples: SupportedPeople[];

  constructor(
    private notificationService: NotificationService,
    private SupportedPeopleService: SupportedPeopleService,
    private projectTypeService: ProjectTypeService,
    public dialogRef: MatDialogRef<DialogProjectComponent>,
    private storage: AngularFireStorage,
    @Inject(MAT_DIALOG_DATA) public data: Project) { }

  ngOnInit(): void {
    this.getProjectType();
    this.getSupportedPeople();
    this.urls = this.data.images;
  }  

  uploadFile(event) {
    for (let index = 0; index < event.length; index++) {
      var n = Date.now();
      const file = event[index];
      const filePath = `chari/${n}`;
      const fileRef = this.storage.ref(filePath);
      const task = this.storage.upload(`chari/${n}`, file);
      task
        .snapshotChanges()
        .pipe(
          finalize(() => {
            this.downloadURL = fileRef.getDownloadURL();
            this.downloadURL.subscribe(url => {
              if (url) {
                this.fb = url;
                this.urls.push(url);
                this.files.push(file.name);
              }
              console.log(this.fb);
            });
          })
        )
        .subscribe(url => {
          if (url) {
            console.log(url);
          }
        });
    }
  }

  test(){
    console.log(this.urls);
  }

  deleteAttachment(index) {
    this.files.splice(index, 1)
    this.urls.splice(index, 1);
  }
  
  public async getProjectType(){
    this.ProjectTypes = await this.projectTypeService.getProjectTypes() as ProjectType[];
  }
  public async getSupportedPeople(){
    this.SupportedPeoples = await this.SupportedPeopleService.getSupportedPeoples() as SupportedPeople[];
  }
  
  save(){
    this.data.videoUrl=this.urls[0];
    this.data.imageUrl=this.urls[0];
    this.data.images=this.urls;
    this.dialogRef.close(this.data);
  }
}
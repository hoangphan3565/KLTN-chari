import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { ProjectType } from '../../../models/ProjectType';
import { NotificationService } from '../../../services/notification.service';
import { Observable } from 'rxjs';
import { AngularFireStorage } from '@angular/fire/storage';
import { finalize } from 'rxjs/operators';

@Component({
    selector: 'app-dialog-project-type',
    templateUrl: './dialog-project-type.component.html',
    styleUrls: ['./dialog-project-type.component.css']
})
export class DialogProjectTypeComponent implements OnInit {
  imageUrl: any;
  downloadURL: Observable<string>;
  
  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogProjectTypeComponent>,
    private storage: AngularFireStorage,
    @Inject(MAT_DIALOG_DATA) public data: ProjectType) { 
      dialogRef.disableClose = true;
    }

  ngOnInit(): void {
    this.imageUrl= this.data.imageUrl;
  } 

  uploadFile(event) {
    for (let index = 0; index < event.length; index++) {
      var n = Date.now();
      const file = event[index];
      const filePath = `charity_program/${n}`;
      const fileRef = this.storage.ref(filePath);
      const task = this.storage.upload(`charity_program/${n}`, file);
      task
        .snapshotChanges()
        .pipe(
          finalize(() => {
            this.downloadURL = fileRef.getDownloadURL();
            this.downloadURL.subscribe(url => {
              if (url) {
                this.imageUrl = (url);
              }
              console.log(this.imageUrl);
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

  deleteAttachment() {
    this.imageUrl=null;
  }

  save(){
    if(this.data.projectTypeName==''){
      this.notificationService.warn('Không được trống thông tin nào');
    }else{
      this.data.imageUrl=this.imageUrl;
      this.dialogRef.close(this.data);
    }
  }
}
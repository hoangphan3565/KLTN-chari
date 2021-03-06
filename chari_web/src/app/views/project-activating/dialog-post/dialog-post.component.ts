import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { NotificationService } from '../../../services/notification.service';
import { Post } from '../../../models/Post';
import { AngularFireStorage } from '@angular/fire/storage';
import { Observable } from 'rxjs';
import { map, finalize } from "rxjs/operators";
import { Project } from '../../../models/Project';
import { ProjectService } from '../../../services/Project.service';

@Component({
    selector: 'app-dialog-post',
    templateUrl: './dialog-post.component.html',
    styleUrls: ['./dialog-post.component.css']
})
export class DialogPostActivatingComponent implements OnInit {

  imageUrls: any = [];
  videoUrl: any;
  downloadURL: Observable<string>;
  Projects: Project[];
  isUploadingVideo: boolean=false;


  constructor(
    private notificationService: NotificationService,
    private projectService: ProjectService,
    public dialogRef: MatDialogRef<DialogPostActivatingComponent>,
    private storage: AngularFireStorage,
    @Inject(MAT_DIALOG_DATA) public data: Post) { 
      dialogRef.disableClose = true;
    }

  ngOnInit(): void {
    this.imageUrls = this.data.images;
    this.videoUrl = this.data.videoUrl;
  }  

  uploadImages(event) {
    for (let index = 0; index < event.length; index++) {
      var n = Date.now();
      const file = event[index];
      const filePath = `chari_post_image/${n}`;
      const fileRef = this.storage.ref(filePath);
      const task = this.storage.upload(`chari_post_image/${n}`, file);
      task
        .snapshotChanges()
        .pipe(
          finalize(() => {
            this.downloadURL = fileRef.getDownloadURL();
            this.downloadURL.subscribe(url => {
              if (url) {
                this.imageUrls.push(url);
              }
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
  uploadVideo(event) {
    this.isUploadingVideo=true;
    for (let index = 0; index < event.length; index++) {
      var n = Date.now();
      const file = event[index];
      const filePath = `chari_post_video/${n}`;
      const fileRef = this.storage.ref(filePath);
      const task = this.storage.upload(`chari_post_video/${n}`, file);
      task
        .snapshotChanges()
        .pipe(
          finalize(() => {
            this.downloadURL = fileRef.getDownloadURL();
            this.downloadURL.subscribe(url => {
              if (url) {
                this.videoUrl=(url);
                this.isUploadingVideo=false;
              }
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


  deleteAttachment(index) {
    this.imageUrls.splice(index, 1);
  }  
  deleteVideo() {
    this.videoUrl=null;
  }
  
  save(){
    this.data.videoUrl=this.videoUrl;
    this.data.imageUrl=this.imageUrls[0];
    this.data.images=this.imageUrls;
    this.dialogRef.close(this.data);
  }
}
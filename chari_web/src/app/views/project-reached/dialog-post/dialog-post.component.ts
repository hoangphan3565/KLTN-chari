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
    styleUrls: ['../../../app.component.css']
})
export class DialogPostReachedComponent implements OnInit {

  imageUrls: any = [];
  videoUrl: any;
  downloadURL: Observable<string>;
  Projects: Project[];
  isUploadingVideo: boolean=false;
  isUpLoadingImage: boolean;
  upLoadingIndex: number;

  constructor(
    private notificationService: NotificationService,
    private projectService: ProjectService,
    public dialogRef: MatDialogRef<DialogPostReachedComponent>,
    private storage: AngularFireStorage,
    @Inject(MAT_DIALOG_DATA) public data: Post) { 
      dialogRef.disableClose = true;
    }

  ngOnInit(): void {
    this.videoUrl = this.data.videoUrl;
    this.initImageArray();
  }  

  initImageArray(): void {
    this.imageUrls = this.data.images;
    let left = this.imageUrls.length;
    for (let i = 0; i < (6-left); i++) {
      this.imageUrls.push("");
    }
  }

  uploadImages(event,i) {
    this.isUpLoadingImage=true;
    this.upLoadingIndex=i;
    if (event.length > 1) {
      this.notificationService.warn('Chỉ được chọn 1 ảnh');
      this.isUpLoadingImage=false;
      this.upLoadingIndex=null;
      return;
    }
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
                this.imageUrls[i] = url;
                this.isUpLoadingImage=false;
                this.upLoadingIndex=null;
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
    if (event.length > 1) {
      this.notificationService.warn('Chỉ được chọn 1 video');
      this.isUploadingVideo=false;
      return;
    }
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


  deleteAttachment(i) {
    this.imageUrls[i]="";
  }  

  deleteVideo() {
    this.videoUrl=null;
  }
  saveImageAndVideo(){
    this.data.videoUrl=this.videoUrl;
    while (this.imageUrls.indexOf("", 0)>-1){
      const index = this.imageUrls.indexOf("", 0);
      if (index > -1) {
        this.imageUrls.splice(index, 1);
      }
    }
    this.data.imageUrl=this.imageUrls[0];
    this.data.images=this.imageUrls;
  }

  save(){
    this.saveImageAndVideo();
    if(this.data.name==''||this.data.content==''||this.data.projectId==null){
      this.notificationService.warn('Hãy điền đầy đủ thông tin')
      return;
    }else if(this.data.imageUrl==null){
      this.notificationService.warn('Hãy tải lên ít nhất 1 hình ảnh cho tin tức')
      return;
    }else{
      this.dialogRef.close(this.data);
    }
  }
}
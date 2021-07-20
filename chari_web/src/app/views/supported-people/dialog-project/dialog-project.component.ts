import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { ProjectType } from '../../../models/ProjectType';
import { NotificationService } from '../../../services/notification.service';
import { Project } from '../../../models/Project';
import { SupportedPeople } from '../../../models/SupportedPeople';
import { ProjectTypeService } from '../../../services/project-type.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { Observable } from 'rxjs';
import { finalize } from "rxjs/operators";
import { CityService } from '../../../services/city.service';
import { City } from '../../../models/City';

@Component({
    selector: 'app-dialog-project',
    templateUrl: './dialog-project.component.html',
    styleUrls: ['../../../app.component.css']
})
export class DialogProjectAddComponent implements OnInit {

  imageUrls: any = [];
  videoUrl: any;
  downloadURL: Observable<string>;
  ProjectTypes: ProjectType[];
  Cities: City[];
  SupportedPeoples: SupportedPeople[];
  canDisburseWhenOverdue:boolean=true;
  isUploadingVideo: boolean;
  isUpLoadingImage: boolean;
  upLoadingIndex: number;

  constructor(
    private notificationService: NotificationService,
    private cityService: CityService,
    private projectTypeService: ProjectTypeService,
    public dialogRef: MatDialogRef<DialogProjectAddComponent>,
    private storage: AngularFireStorage,
    @Inject(MAT_DIALOG_DATA) public data: Project) { 
      dialogRef.disableClose = true;
    }

  ngOnInit(): void {
    this.getProjectType();
    this.getCity();
    this.initImageArray();
    this.videoUrl = this.data.videoUrl;
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
      const filePath = `chari_video/${n}`;
      const fileRef = this.storage.ref(filePath);
      const task = this.storage.upload(`chari_video/${n}`, file);
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
  
  public async getCity(){
    this.Cities = await (await this.cityService.getCities()).data as City[];
  }

  public async getProjectType(){
    this.ProjectTypes = await (await this.projectTypeService.getProjectTypes()).data as ProjectType[];
  }

  changeState(){
    if(this.canDisburseWhenOverdue==true){
      this.canDisburseWhenOverdue=false;
    }else{
      this.canDisburseWhenOverdue=true;
    }
  }

  filterProjectType(){
    return this.ProjectTypes.filter(x => x.canDisburseWhenOverdue == this.canDisburseWhenOverdue);
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
    if(this.data.projectName==''||this.data.briefDescription==''||this.data.description==''||this.data.cti_ID==null||this.data.startDate==''||this.data.endDate==''||this.data.targetMoney==''||this.data.prt_ID==null||this.data.stp_ID==null){
      this.notificationService.warn('Hãy điền và chọn đầy đủ thông tin')
      return;
    }else if(this.data.description.length<300){
      this.notificationService.warn('Hãy điền nội dung dự án tối thiểu 100 từ')
      return;
    }else if(this.data.imageUrl==null){
      this.notificationService.warn('Hãy tải lên ít nhất 1 hình ảnh cho tin tức')
      return;
    }else{
      this.dialogRef.close(this.data);
    }
  }
}
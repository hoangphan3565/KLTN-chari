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
import { CityService } from '../../../services/city.service';
import { City } from '../../../models/City';
import { SupportedPeopleRecommend } from '../../../models/SupportedPeopleRecommend';
import { SupportedPeopleRecommendService } from '../../../services/supported-people-recommend.service';

@Component({
    selector: 'app-dialog-project',
    templateUrl: './dialog-project.component.html',
    styleUrls: ['./dialog-project.component.css']
})
export class DialogProjectAddComponent implements OnInit {

  imageUrls: any = [];
  videoUrl: any;
  downloadURL: Observable<string>;
  ProjectTypes: ProjectType[];
  Cities: City[];
  SupportedPeoples: SupportedPeople[];
  canDisburseWhenOverdue:boolean;
  isUploadingVideo: boolean;

  constructor(
    private notificationService: NotificationService,
    private supportedPeopleRecommendService: SupportedPeopleRecommendService,
    private cityService: CityService,
    private projectTypeService: ProjectTypeService,
    public dialogRef: MatDialogRef<DialogProjectAddComponent>,
    private storage: AngularFireStorage,
    @Inject(MAT_DIALOG_DATA) public data: SupportedPeopleRecommend) { 
      dialogRef.disableClose = true;
    }

  ngOnInit(): void {
    this.getProjectType();
    this.getCity();
    this.imageUrls = this.data.images;
    this.videoUrl = this.data.videoUrl;
    if(this.data.projectType!=null){
      this.canDisburseWhenOverdue = this.data.projectType.canDisburseWhenOverdue;
    }else{
      this.canDisburseWhenOverdue = this.data.canDisburseWhenOverdue;
    }
  }  

  uploadImages(event) {
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


  deleteAttachment(index) {
    this.imageUrls.splice(index, 1);
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
  
  save(){
    this.data.videoUrl=this.videoUrl;
    this.data.imageUrl=this.imageUrls[0];
    this.data.images=this.imageUrls;
    this.dialogRef.close(this.data);
  }

  finish(){
    this.data.videoUrl=this.videoUrl;
    this.data.imageUrl=this.imageUrls[0];
    this.data.images=this.imageUrls;
    if(confirm('Dự án mới sẽ được tạo và đưa vào trạng thái đang hoạt động')){
      this.dialogRef.close(this.data);
    }
  }

  async saveDraft(){
    this.data.videoUrl=this.videoUrl;
    this.data.imageUrl=this.imageUrls[0];
    this.data.images=this.imageUrls;
    const res = await (await this.supportedPeopleRecommendService.saveDraft2(this.data)).data;
    this.notificationService.warn(res.message);
  }
  
  back(){
    this.dialogRef.close('back');
  }

  unHandle(){
    if(confirm('Bạn có thực sự muốn hủy xử lý hoàn cảnh này')){
      this.supportedPeopleRecommendService.unHandle(this.data.sprID);
      this.dialogRef.close('delete');
    }
  }
}
import { OnInit } from '@angular/core';
import { Component } from '@angular/core';
import { User } from '../../models/User';
import { AuthService } from '../../services/auth.service';
import { NotificationService } from '../../services/notification.service';
import { AngularFireStorage } from '@angular/fire/storage';
import { Observable } from 'rxjs';
import { finalize } from 'rxjs/operators';

@Component({
  selector: 'app-dashboard',
  templateUrl: 'register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit{
  user : User;
  imageUrl: any;
  downloadURL: Observable<string>;

  constructor( private authService: AuthService,private notificationService: NotificationService, private storage: AngularFireStorage,) { }

  ngOnInit(): void {
    this.user = {
      name: '',
      email: '',
      phone: '',
      username:'',
      password1: '',
      password2: '',
      certificate: null,
      usertype:'Collaborator'
    };  
  }  

  uploadImages(event) {
    for (let index = 0; index < event.length; index++) {
      const file = event[index];
      const filePath = `collaborator_certificate/${this.user.username}`;
      const fileRef = this.storage.ref(filePath);
      const task = this.storage.upload(`collaborator_certificate/${this.user.username}`, file);
      task
        .snapshotChanges()
        .pipe(
          finalize(() => {
            this.downloadURL = fileRef.getDownloadURL();
            this.downloadURL.subscribe(url => {
              if (url) {
                this.imageUrl = (url);
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
  deleteAttachment() {
    this.imageUrl=null;
  }
  getName(data){
    this.user.name=data;
  }
  getEmail(data){
    this.user.email=data;
  }
  getPhone(data){
    this.user.phone=data;
  }
  getUsername(data){
    this.user.username=data;
  }
  getPassword1(data){
    this.user.password1=data;
  }
  getPassword2(data){
    this.user.password2=data;
  }

  public async register(){
    this.user.certificate = this.imageUrl;
    if(this.user.email!='' && this.user.username!='' && this.user.password1!='' && this.user.password2!=''){
      if(this.user.password1 == this.user.password2){
        if(this.user.certificate != null){
          const res = await (await this.authService.register(this.user)).data as any;
          console.log(res)
          if(res){
            if(res.errorCode == 0){
              if(res.data.usertype=="Collaborator"){
                this.notificationService.warn(res.message);
                window.location.href="/#/lading";
              }else{
                this.notificationService.warn('Đăng ký thất bại');
              }
            }else{
              this.notificationService.warn(res.message);
            }
          }else{
            this.notificationService.warn('Đăng ký thất bại');
          }
        }else{
          this.notificationService.warn('Hãy tải lên hình chụp chứng chỉ từ thiện!');
        }
      }else{
        this.notificationService.warn('Mật khẩu phải trùng khớp');
      }
    }else{
      this.notificationService.warn('Không được để trống thông tin');
    }
  }

}

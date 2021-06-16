import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { NotificationService } from '../../services/notification.service';
import Cookies from 'js-cookie'

@Component({
  selector: 'app-dashboard',
  templateUrl: 'login.component.html'
})
export class LoginComponent{
  username: string;
  password: string;
  constructor(
    private authService: AuthService,
    private notificationService: NotificationService,) { 
    }

  getUsername(data){
    this.username=data;
  }
  getPassword(data){
    this.password=data;
  }
  public async login(){
    const res = await (await this.authService.login(this.username,this.password)).data as any;
    console.log(res)
    if(res){
      if(res.errorCode == 0){
        if(res.data.usertype=="Collaborator"&&res.data.status=='ACTIVATED'){
          this.notificationService.warn('Đăng nhập thành công');
          Cookies.set("loginInfo",JSON.stringify(res),{expires: 1});
          window.location.href="/dashboard";
        }else{
          this.notificationService.warn('Đăng nhập thất bại! Tài khoản đã bị khoá!');
        }
      } else{
        this.notificationService.warn('Đăng nhập thất bại');
      }
    }else{
      this.notificationService.warn('Đăng nhập thất bại');
    }
  }
}

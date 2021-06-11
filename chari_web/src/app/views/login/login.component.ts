import { Component } from '@angular/core';
import { LoginService } from '../../services/login.service';
import { NotificationService } from '../../services/notification.service';
import Cookies from 'js-cookie'

@Component({
  selector: 'app-dashboard',
  templateUrl: 'login.component.html'
})
export class LoginComponent{
  user: any;
  username: string;
  password: string;
  constructor(
    private loginService: LoginService,
    private notificationService: NotificationService,) { 
    }

  getUsername(data){
    this.username=data;
  }
  getPassword(data){
    this.password=data;
  }
  public async login(){
    const res = await this.loginService.login(this.username,this.password) as any;
    console.log(res)
    if(res){
      if(res.errorCode == 0){
        if(res.data.usertype=="Admin"){
          this.notificationService.warn('Đăng nhập thành công');
          Cookies.set("loginInfo",JSON.stringify(res),{expires: 1});
          window.location.href="/dashboard";
        }else{
          this.notificationService.warn('Đăng nhập thất bại');
        }
      } else{
        this.notificationService.warn('Đăng nhập thất bại');
      }
    }else{
      this.notificationService.warn('Đăng nhập thất bại');
    }
  }
}

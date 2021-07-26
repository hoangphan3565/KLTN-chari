import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
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
    try {
      const res = await (await this.authService.login(this.username,this.password)).data as any;
      if(res){
        if(res.errorCode == 0){
          if(res.data.usertype=="Admin"){
            this.notificationService.warn('Đăng nhập thành công');
            Cookies.set("loginInfo",JSON.stringify(res),{expires: 1});
            window.location.href="/";
          }else{
            this.notificationService.warn('Đăng nhập thất bại');
          }
        } else{
          this.notificationService.warn('Đăng nhập thất bại');
        }
      }else{
        this.notificationService.warn('Đăng nhập thất bại');
      }
    }catch(e){
      this.notificationService.warn('Sai tên đăng nhập hoặc mật khẩu');
    }
  }
}

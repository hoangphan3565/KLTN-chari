import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { User } from '../../models/User';
import { NotificationService } from '../../services/notification.service';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-User',
  templateUrl: './User.component.html',
})
export class UserComponent implements OnInit {
  Users: User[];
  isEdit: boolean;

  constructor(
    private UserService: UserService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getUser()
  }
  public async getUser(){
    this.Users = await this.UserService.getUsers() as User[];
  }


  public blockUser = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn khoá người dùng này?')){
        const result = await this.UserService.blockUser(id);
        if (result)
        {
          this.notificationService.warn('Khoá người dùng thành công');
          this.Users = result as User[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
  public unblockUser = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn mở khoá người dùng này?')){
        const result = await this.UserService.unblockUser(id);
        if (result)
        {
          this.notificationService.warn('Mở khoá người dùng thành công');
          this.Users = result as User[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}

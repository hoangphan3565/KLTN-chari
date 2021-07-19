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

    maxSize: number = 5;
    totalItems: number;
    itemsPerPage: number = 5;
    currentPage: number = 1;
    
  
    pageChanged(event: any): void {
      this.currentPage =  event.page;
      this.getList(this.currentPage,this.itemsPerPage);
    }
  
    public options = [
      {"id": 1, "value": 5},
      {"id": 2, "value": 10},
      {"id": 3, "value": 25},
      {"id": 4, "value": 100},
    ]
    public selected1 = this.options[0].id;
  
    rowsChanged(event: any): void {
      this.itemsPerPage = this.options[event.value-1].value;
      this.getList(this.currentPage,this.itemsPerPage);
    }
  
  
    ngOnInit(): void {
      this.countTotal();
      this.getList(1,this.itemsPerPage)
    }
    public async countTotal(){
      this.totalItems = await (await this.UserService.countTotal()).data;
    }
    public async getList(a,b){
      this.Users = await (await this.UserService.getPerPage(a,b)).data as User[];
    }


  public blockUser = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn khoá người dùng này?')){
        const res = await this.UserService.blockUser(id);
        if (res)
        {
          this.notificationService.warn('Khoá người dùng thành công');
          this.Users = res.data as User[];
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
        const res = await this.UserService.unblockUser(id);
        if (res)
        {
          this.notificationService.warn('Mở khoá người dùng thành công');
          this.Users = res.data as User[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}

import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { PushNotification } from '../../models/PushNotification';
import { NotificationService } from '../../services/notification.service';
import { PushNotificationService } from '../../services/push-notification.service';
import { DialogPushNotificationComponent } from './dialog-push-notification/dialog-push-notification.component';

@Component({
  selector: 'app-push-notification',
  templateUrl: './push-notification.component.html',
})
export class PushNotificationComponent implements OnInit {

  PushNotifications: PushNotification[];
  PushNotification: PushNotification;

  constructor(
    private PushNotificationService: PushNotificationService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getPushNotification()
  }

  public async getPushNotification(){
    this.PushNotifications = await (await this.PushNotificationService.getPushNotifications()).data as PushNotification[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPushNotificationComponent, {
      width: '350px',
      data: this.PushNotification,
    });
    dialogRef.afterClosed().subscribe((res: PushNotification) => {
      if(res){
        if (res.nof_ID==null) this.savePushNotification(res,'Thêm');
        else this.savePushNotification(res,'Cập nhật');
      }
    });
  }
  openEditDialog(n : PushNotification): void {
    this.PushNotification = {
      nof_ID:n.nof_ID,
      title:n.title,
      message:n.message,
      topic:n.topic,
    }; 
    this.openDialog();
  }
  clearData(){
    this.PushNotification = {
      nof_ID:null,
      title:'',
      message:'',
      topic:null,
    };
  }

  public savePushNotification = async (data,state) => {
    try 
    {
      const res = await this.PushNotificationService.savePushNotification(data);
      if (res)
      {
        this.notificationService.success(state+' thông báo đẩy thành công');
        this.PushNotifications = res.data as PushNotification[];
      }    
    }
    catch (e) {
      alert(state+' thông báo đẩy thất bại');
    }
  };
}

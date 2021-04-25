import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { PushNotification } from '../../models/PushNotification';
import { NotificationService } from '../../services/notification.service';
import { PushNotificationService } from '../../services/push-notification.service';

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
    this.PushNotifications = await this.PushNotificationService.getPushNotifications() as PushNotification[];
  }

  public deletePushNotification = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá thông báo đẩy này?')){
        const result = await this.PushNotificationService.deletePushNotification(id);
        if (result)
        {
          this.notificationService.warn('Xoá thông báo đẩy thành công');
          this.PushNotifications = result as PushNotification[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}

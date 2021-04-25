import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { PushNotificationTopic } from '../../models/PushNotificationTopic';
import { NotificationService } from '../../services/notification.service';
import { PushNotificationTopicService } from '../../services/push-notification-topic.service';
import { DialogPushNotificationTopicComponent } from './dialog-push-notification-topic/dialog-push-notification-topic.component';

@Component({
  templateUrl: './push-notification-topic.component.html',
})
export class PushNotificationTopicComponent implements OnInit {


  PushNotificationTopics: PushNotificationTopic[];
  PushNotificationTopic: PushNotificationTopic;

  constructor(
    private PushNotificationTopicService: PushNotificationTopicService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getPushNotificationTopic()
  }
  public async getPushNotificationTopic(){
    this.PushNotificationTopics = await this.PushNotificationTopicService.getPushNotificationTopics() as PushNotificationTopic[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPushNotificationTopicComponent, {
      width: '250px',
      data: this.PushNotificationTopic,
    });
    dialogRef.afterClosed().subscribe((result: PushNotificationTopic) => {
      if (result.tpc_ID==null) this.savePushNotificationTopic(result,'Thêm');
      else this.savePushNotificationTopic(result,'Cập nhật');
    });
  }
  openEditDialog(c : PushNotificationTopic): void {
    this.PushNotificationTopic = {
      tpc_ID:c.tpc_ID,
      topicName:c.topicName,
      description:c.description,
    }
    this.openDialog();
  }
  clearData(){
    this.PushNotificationTopic = new PushNotificationTopic;
    this.PushNotificationTopic.tpc_ID=null;
  }

  public savePushNotificationTopic = async (data,state) => {
    try 
    {
      const result = await this.PushNotificationTopicService.savePushNotificationTopic(data);
      if (result)
      {
        this.notificationService.success(state+' topic thông báo thành công');
        this.PushNotificationTopics = result as PushNotificationTopic[];
      }    
    }
    catch (e) {
      alert(state+' topic thông báo thất bại');
    }
  };


  public deletePushNotificationTopic = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá topic thông báo này?')){
        const result = await this.PushNotificationTopicService.deletePushNotificationTopic(id);
        if (result)
        {
          this.notificationService.warn('Xoá topic thông báo thành công');
          this.PushNotificationTopics = result as PushNotificationTopic[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

}

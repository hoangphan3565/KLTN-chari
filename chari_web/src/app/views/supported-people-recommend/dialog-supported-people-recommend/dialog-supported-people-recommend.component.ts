import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { SupportedPeopleRecommend } from '../../../models/SupportedPeopleRecommend';
import { NotificationService } from '../../../services/notification.service';
import { SupportedPeopleRecommendService } from '../../../services/supported-people-recommend.service';

@Component({
    selector: 'app-dialog-supported-people-recommend',
    templateUrl: './dialog-supported-people-recommend.component.html',
    styleUrls: ['./dialog-supported-people-recommend.component.css']

  })
export class DialogSupportedPeopleRecommendComponent implements OnInit {
  constructor(
    private notificationService: NotificationService,
    private apiService: SupportedPeopleRecommendService,
    public dialogRef: MatDialogRef<DialogSupportedPeopleRecommendComponent>,
    @Inject(MAT_DIALOG_DATA) public data: SupportedPeopleRecommend) {
      dialogRef.disableClose = true;  
    }
  
  ngOnInit(): void {
  }

  async saveDraft(){
    const res = await (await this.apiService.saveDraft1(this.data)).data;
    this.notificationService.warn(res.message);
  }
  
  unHandle(){
    if(confirm('Bạn có thực sự muốn hủy xử lý hoàn cảnh này')){
      this.apiService.unHandle(this.data.sprID);
    }
  }

  nextStep(){
    if(this.data.fullName==null || this.data.address==null ||this.data.phoneNumber==null||this.data.bankName==null||this.data.bankAccount==null){
      this.notificationService.warn('Hãy điền thông tin còn thiếu');
    }else{
      this.apiService.saveDraft1(this.data);
      this.dialogRef.close(this.data);
    }
  }
}

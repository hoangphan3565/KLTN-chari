import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { ProjectType } from '../../../models/ProjectType';
import { NotificationService } from '../../../services/notification.service';

@Component({
    selector: 'app-dialog-extend',
    templateUrl: './dialog-extend.component.html',
})
export class DialogExtendComponent implements OnInit {
  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogExtendComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit(): void {
  }  
  save(){
    if(this.data=='' || this.data>365 || this.data < 30){
      this.notificationService.warn('Số ngày phải lớn hơn 30 và nhỏ hơn 365!');
    }else{
      this.dialogRef.close(this.data);
    }
  }
}
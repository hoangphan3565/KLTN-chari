import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { Donator } from '../../../models/Donator';
import { NotificationService } from '../../../services/notification.service';

@Component({
  selector: 'app-dialog-donator',
  templateUrl: './dialog-donator.component.html',
})
export class DialogDonatorComponent implements OnInit {

  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogDonatorComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Donator) { }

  ngOnInit(): void {
  }

  save(){
    if(this.data.fullName=='' || this.data.address=='' ||this.data.phoneNumber==''){
      this.notificationService.warn('Không được trống thông tin nào!');
    }else{
      this.dialogRef.close(this.data);
    }
  }
}



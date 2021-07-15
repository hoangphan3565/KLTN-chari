import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { SupportedPeople } from '../../../models/SupportedPeople';
import { NotificationService } from '../../../services/notification.service';

@Component({
    selector: 'app-dialog-supported-people',
    templateUrl: './dialog-supported-people.component.html',
  })
export class DialogSupportedPeopleComponent implements OnInit {
  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogSupportedPeopleComponent>,
    @Inject(MAT_DIALOG_DATA) public data: SupportedPeople) { 
      dialogRef.disableClose = true;
    }
  
  ngOnInit(): void {
  }

  save(){
    if(this.data.fullName=='' || this.data.address=='' ||this.data.phoneNumber==''||this.data.bankAccount==''){
      this.notificationService.warn('Không được trống thông tin nào');
    }else{
      this.dialogRef.close(this.data);
    }
  }
}

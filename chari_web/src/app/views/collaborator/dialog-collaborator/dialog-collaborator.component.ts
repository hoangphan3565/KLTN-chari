import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { Collaborator } from '../../../models/Collaborator';
import { NotificationService } from '../../../services/notification.service';

@Component({
  selector: 'app-dialog-collaborator',
  templateUrl: './dialog-collaborator.component.html',
})
export class DialogCollaboratorComponent implements OnInit {
  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogCollaboratorComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Collaborator) { }

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
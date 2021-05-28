import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { NotificationService } from '../../../services/notification.service';

@Component({
    templateUrl: './dialog-disburse-project.component.html',
  })
export class DialogDisburseProjectComponent implements OnInit {
  disburseCode: string;

  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogDisburseProjectComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }
  
  ngOnInit(): void {
    this.disburseCode = 'DISBURSE'+this.data.prj_id+'T'
  }
}

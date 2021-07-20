import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { NotificationService } from '../../../services/notification.service';
import { Project } from '../../../models/Project';

@Component({
    templateUrl: './dialog-disburse-project.component.html',
    styleUrls: ['../../../app.component.css']
  })
export class DialogDisburseProjectComponent implements OnInit {
  disburseCode: string;

  constructor(
    private notificationService: NotificationService,
    public dialogRef: MatDialogRef<DialogDisburseProjectComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Project) { 
      dialogRef.disableClose = true;
    }
  
  ngOnInit(): void {
    this.disburseCode = 'GIAINGAN'+this.data.prj_ID
  }
}

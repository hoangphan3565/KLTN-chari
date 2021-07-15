import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { Project } from '../../../models/Project';

@Component({
    templateUrl: './dialog-donateinfo-project.component.html',
    styleUrls: ['./dialog-donateinfo-project.component.css']
  })
export class DialogDonateInfoComponent implements OnInit {
  disburseCode: string;
  fullName: string='PHAN DINH HOANG';
  bankName: string='BIDV Chi nhánh Đông Sài Gòn';
  bankAccount: string='31410002593895';
  constructor(
    public dialogRef: MatDialogRef<DialogDonateInfoComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Project) { 
      dialogRef.disableClose = true;
    }
  
  ngOnInit(): void {
    this.disburseCode = `CHARI${this.data.prj_ID}xSDT`
  }
}

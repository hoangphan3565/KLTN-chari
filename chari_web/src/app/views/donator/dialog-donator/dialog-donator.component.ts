import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { Donator } from '../../../models/Donator';

@Component({
    selector: 'app-dialog-donator',
    templateUrl: './dialog-donator.component.html',
  })
  export class DialogDonatorComponent implements OnInit {

    constructor(
      public dialogRef: MatDialogRef<DialogDonatorComponent>,
      @Inject(MAT_DIALOG_DATA) public data: Donator) { }
  
    ngOnInit(): void {
    }

    save(){this.dialogRef.close(this.data);}
  }
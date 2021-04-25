import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { SupportedPeople } from '../../../models/SupportedPeople';

@Component({
    selector: 'app-dialog-supported-people',
    templateUrl: './dialog-supported-people.component.html',
  })
  export class DialogSupportedPeopleComponent implements OnInit {

    constructor(
      public dialogRef: MatDialogRef<DialogSupportedPeopleComponent>,
      @Inject(MAT_DIALOG_DATA) public data: SupportedPeople) { }
  
    ngOnInit(): void {
    }

    save(){
        this.dialogRef.close(this.data);
    }
  }
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { Collaborator } from '../../../models/Collaborator';

@Component({
    selector: 'app-dialog-collaborator',
    templateUrl: './dialog-collaborator.component.html',
  })
  export class DialogCollaboratorComponent implements OnInit {
    constructor(
      public dialogRef: MatDialogRef<DialogCollaboratorComponent>,
      @Inject(MAT_DIALOG_DATA) public data: Collaborator) { }
  
    ngOnInit(): void {
    }
  
    save(){
        this.dialogRef.close(this.data);
    }
  }
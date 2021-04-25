import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { ProjectType } from '../../../models/ProjectType';

@Component({
    selector: 'app-dialog-project-type',
    templateUrl: './dialog-project-type.component.html',
  })
  export class DialogProjectTypeComponent implements OnInit {
    constructor(
      public dialogRef: MatDialogRef<DialogProjectTypeComponent>,
      @Inject(MAT_DIALOG_DATA) public data: ProjectType) { }
  
    ngOnInit(): void {
    }  
    save(){
        this.dialogRef.close(this.data);
    }
  }
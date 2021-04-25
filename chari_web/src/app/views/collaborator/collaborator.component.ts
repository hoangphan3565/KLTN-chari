import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Collaborator } from '../../models/Collaborator';
import { NotificationService } from '../../services/notification.service';
import { CollaboratorService } from '../../services/collaborator.service';
import { DialogCollaboratorComponent } from './dialog-collaborator/dialog-collaborator.component';

@Component({
  templateUrl: './collaborator.component.html',
})
export class CollaboratorComponent implements OnInit {


  Collaborators: Collaborator[];
  Collaborator: Collaborator;

  constructor(
    private CollaboratorService: CollaboratorService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getCollaborator()
  }
  public async getCollaborator(){
    this.Collaborators = await this.CollaboratorService.getCollaborators() as Collaborator[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogCollaboratorComponent, {
      width: '250px',
      data: this.Collaborator,
    });
    dialogRef.afterClosed().subscribe((result: Collaborator) => {
      if (result.clb_ID==null) this.saveCollaborator(result,'Thêm');
      else this.saveCollaborator(result,'Cập nhật');
    });
  }
  openEditDialog(c : Collaborator): void {
    this.Collaborator = {
      clb_ID:c.clb_ID,
      fullName:c.fullName,
      address:c.address,
      phoneNumber:c.phoneNumber,
      certificate:c.certificate
    }
    this.openDialog();
  }
  clearData(){
    this.Collaborator = new Collaborator;
    this.Collaborator.clb_ID=null;
  }

  public saveCollaborator = async (data,state) => {
    try 
    {
      const result = await this.CollaboratorService.saveCollaborator(data);
      if (result)
      {
        this.notificationService.success(state+' công tác viên thành công');
        this.Collaborators = result as Collaborator[];
      }    
    }
    catch (e) {
      alert(state+' công tác viên thất bại');
    }
  };


  public deleteCollaborator = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá công tác viên này?')){
        const result = await this.CollaboratorService.deleteCollaborator(id);
        if (result)
        {
          this.notificationService.warn('Xoá công tác viên thành công');
          this.Collaborators = result as Collaborator[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

}

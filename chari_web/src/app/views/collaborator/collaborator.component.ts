import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Collaborator } from '../../models/Collaborator';
import { NotificationService } from '../../services/notification.service';
import { CollaboratorService } from '../../services/collaborator.service';

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
    this.Collaborators = await (await this.CollaboratorService.getCollaborators()).data as Collaborator[];
  }

  public acceptCollaborator = async (data) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn duyệt cộng tác viên?')){
        const res = await this.CollaboratorService.accept(data.clb_ID);
        if (res)
        {
          this.notificationService.success('Duyệt cộng tác viên thành công');
          this.Collaborators = res.data as Collaborator[];
        } 
      }
    }
    catch (e) {
      this.notificationService.success('Duyệt cộng tác viên thất bại');
    }
  };

  public blockCollaborator = async (data) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn khoá cộng tác viên?')){
        const res = await this.CollaboratorService.block(data.clb_ID);
        if (res)
        {
          this.notificationService.success('Khóa cộng tác viên thành công');
          this.Collaborators = res.data as Collaborator[];
        }   
      }
    }
    catch (e) {
      this.notificationService.warn('Khóa cộng tác viên thất bại');
    }
  };


  public deleteCollaborator = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá cộng tác viên này?')){
        const res = await this.CollaboratorService.deleteCollaborator(id);
        if (res)
        {
          this.notificationService.success('Xoá cộng tác viên thành công');
          this.Collaborators = res.data as Collaborator[];
        }
      }
    }
    catch (e) {
      console.log(e);
      this.notificationService.warn('Không thể xóa cộng tác viên');
    }
  }

}

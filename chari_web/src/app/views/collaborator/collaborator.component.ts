import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Collaborator } from '../../models/Collaborator';
import { NotificationService } from '../../services/notification.service';
import { CollaboratorService } from '../../services/collaborator.service';

@Component({
  templateUrl: './collaborator.component.html',
})
export class CollaboratorComponent implements OnInit {
  constructor(
    private CollaboratorService: CollaboratorService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  Collaborators: Collaborator[];
  Collaborator: Collaborator;


  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;
  

  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getList(this.currentPage,this.itemsPerPage);
  }

  public options = [
    {"id": 1, "value": 5},
    {"id": 2, "value": 10},
    {"id": 3, "value": 25},
    {"id": 4, "value": 100},
  ]
  public selected1 = this.options[0].id;

  rowsChanged(event: any): void {
    this.itemsPerPage = this.options[event.value-1].value;
    this.getList(this.currentPage,this.itemsPerPage);
  }


  ngOnInit(): void {
    this.countTotal();
    this.getList(1,this.itemsPerPage)
  }
  public async countTotal(){
    this.totalItems = await (await this.CollaboratorService.countTotal()).data;
  }
  public async getList(a,b){
    this.Collaborators = await (await this.CollaboratorService.getPerPage(a,b)).data as Collaborator[];
  }

  public acceptCollaborator = async (data) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn duyệt cộng tác viên?')){
        const res = await this.CollaboratorService.accept(data.clb_ID);
        if (res)
        {
          this.notificationService.success('Duyệt cộng tác viên thành công');
          this.getList(this.currentPage,this.itemsPerPage);
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
          this.getList(this.currentPage,this.itemsPerPage);
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
          this.getList(this.currentPage,this.itemsPerPage);
        }
      }
    }
    catch (e) {
      console.log(e);
      this.notificationService.warn('Không thể xóa cộng tác viên');
    }
  }

}

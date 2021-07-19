import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogExtendComponent } from './dialog-extend/dialog-extend.component';
import Cookies from 'js-cookie'

@Component({
  templateUrl: './project-overdue.component.html',
})
export class ProjectOverdueComponent implements OnInit {
  Projects: Project[];
  clb_id: Number;

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

  constructor(
    private projectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.countTotal();
    this.getList(1,this.itemsPerPage);
  }

  public async countTotal(){
    this.totalItems = await (await this.projectService.countOverdue(this.clb_id)).data;
  }

  public async getList(a,b){
    this.Projects = await (await this.projectService.getOverdue(this.clb_id,a,b)).data as Project[];
  } 

  public closeProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự đóng dự án này?')){
        const res = await (await this.projectService.closeProject(id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getList(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

  openExtendDialog(id): void {
    const dialogRef = this.dialog.open(DialogExtendComponent, {
      width: '250px',
      data: 30 
    });
    dialogRef.afterClosed().subscribe((res: Number) => {
      if(res){
        this.extendProject(id,res);
      }
    });
  }
  

  public extendProject = async (id,nod) => {
    try 
    {
      const res = await (await this.projectService.extendProject(id,nod)).data;
      if (res)
      {
        this.notificationService.warn(res.message);
        this.getList(this.currentPage,this.itemsPerPage);
      }  
    }
    catch (e) {
      console.log(e);
    }
  }
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }
}


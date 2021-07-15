import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import Cookies from 'js-cookie'


@Component({
  templateUrl: './project-closed.component.html',
})
export class ProjectClosedComponent implements OnInit {
  Projects: any[];
  clb_id: Number;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;

  
  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getClosed(this.currentPage,this.itemsPerPage);

  }
  rowsChanged(event: any): void {
    this.itemsPerPage =  event.value;
    this.getClosed(this.currentPage,this.itemsPerPage);
  }

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.getClosed(1,this.itemsPerPage)
  }

  public async getTotalPost(){
    this.totalItems = await (await this.ProjectService.coutClosed(this.clb_id)).data;
  }

  async getClosed(a,b){
    this.Projects = await (await this.ProjectService.getClosed(this.clb_id,a,b)).data as any[];
  }

  async updateMoveMoneyProgress(){
    const res = await (await this.ProjectService.updateMoveMoneyProgress()).data as any[];
  }
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }
}


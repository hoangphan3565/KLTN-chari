import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';

@Component({
  templateUrl: './project-closed.component.html',
})
export class ProjectClosedComponent implements OnInit {
  Projects: any[];

  constructor(
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getTotalPost();
    this.getClosed(1,this.itemsPerPage);
    this.updateMoveMoneyProgress()
  };

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number = 5;
  currentPage: number = 1;


  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getClosed(this.currentPage,this.itemsPerPage);
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
    this.getClosed(this.currentPage,this.itemsPerPage);
  }

  public async getTotalPost(){
    this.totalItems = await (await this.ProjectService.countClosedProjects()).data;
  }


  async getClosed(a,b,){
    this.Projects = await (await this.ProjectService.getClosed(a,b)).data as any[];
  };

  async updateMoveMoneyProgress(){
    const res = await (await this.ProjectService.updateMoveMoneyProgress()).data as any[];
    if (res)
    {
      this.Projects = res as any[];
    }   
  };

  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  };
}


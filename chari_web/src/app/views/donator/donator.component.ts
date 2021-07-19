import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Donator } from '../../models/Donator';
import { NotificationService } from '../../services/notification.service';
import { DonatorService } from '../../services/donator.service';

@Component({
  selector: 'app-donator',
  templateUrl: './donator.component.html',
})
export class DonatorComponent implements OnInit {

  Donators: Donator[];
  Donator: Donator;

  constructor(
    private DonatorService: DonatorService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

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
    this.totalItems = await (await this.DonatorService.countTotal()).data;
  }
  public async getList(a,b){
    this.Donators = await (await this.DonatorService.getPerPage(a,b)).data as Donator[];
  }
}

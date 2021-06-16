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

  ngOnInit(): void {
    this.getDonator()
  }
  public async getDonator(){
    this.Donators = await (await this.DonatorService.getDonators()).data as Donator[];
  }
}

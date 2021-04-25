import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Donator } from '../../models/Donator';
import { NotificationService } from '../../services/notification.service';
import { DonatorService } from '../../services/donator.service';
import { DialogDonatorComponent } from './dialog-donator/dialog-donator.component';

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
    this.Donators = await this.DonatorService.getDonators() as Donator[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogDonatorComponent, {
      width: '250px',
      data: this.Donator
    });
    dialogRef.afterClosed().subscribe((result: Donator) => {
      if (result.dnt_ID==null) this.saveDonator(result,'Thêm');
      else this.saveDonator(result,'Cập nhật');
      
    });
  }
  openEditDialog(d : Donator): void {
    this.Donator = {
      dnt_ID:d.dnt_ID,
      fullName:d.fullName,
      address:d.address,
      phoneNumber:d.phoneNumber,
    }
    this.openDialog();
  }
  clearData(){
    this.Donator = new Donator;
    this.Donator.dnt_ID=null;
  }

  public saveDonator = async (data,state) => {
    try 
    {
      const result = await this.DonatorService.saveDonator(data);
      if (result)
      {
        this.notificationService.success(state+' nhà từ thiện thành công');
        this.Donators = result as Donator[];
      }    
    }
    catch (e) {
      alert(state+' nhà từ thiện thất bại');
    }
  };


  public deleteDonator = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá nhà từ thiện này?')){
        const result = await this.DonatorService.deleteDonator(id);
        if (result)
        {
          this.notificationService.warn('Xoá nhà từ thiện thành công');
          this.Donators = result as Donator[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

}

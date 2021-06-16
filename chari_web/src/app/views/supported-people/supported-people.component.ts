import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { SupportedPeople } from '../../models/SupportedPeople';
import { NotificationService } from '../../services/notification.service';
import { SupportedPeopleService } from '../../services/supported-people.service';
import { DialogSupportedPeopleComponent } from './dialog-supported-people/dialog-supported-people.component';

@Component({
  selector: 'app-supported-people',
  templateUrl: './supported-people.component.html',
})
export class SupportedPeopleComponent implements OnInit {

  SupportedPeoples: SupportedPeople[];
  SupportedPeople: SupportedPeople;

  constructor(
    private SupportedPeopleService: SupportedPeopleService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getSupportedPeople()
  }
  public async getSupportedPeople(){
    this.SupportedPeoples = await (await this.SupportedPeopleService.getSupportedPeoples()).data as SupportedPeople[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogSupportedPeopleComponent, {
      width: '250px',
      data: this.SupportedPeople
    });
    dialogRef.afterClosed().subscribe((result: SupportedPeople) => {
      if(result){
        if (result.stp_ID==null) this.saveSupportedPeople(result,'Thêm'); 
        else this.saveSupportedPeople(result,'Cập nhật');      
      }
    });
  }
  openEditDialog(sp : SupportedPeople): void {
    this.SupportedPeople = {
      stp_ID:sp.stp_ID,
      fullName:sp.fullName,
      address:sp.address,
      phoneNumber:sp.phoneNumber,
      bankName:sp.bankName,
      bankAccount:sp.bankAccount,
    }
    this.openDialog();
  }
  clearData(){
    this.SupportedPeople = new SupportedPeople;
    this.SupportedPeople.stp_ID=null;
  }
  public saveSupportedPeople = async (data,state) => {
    try 
    {
      const result = await this.SupportedPeopleService.saveSupportedPeople(data);
      if (result)
      {
        this.notificationService.success(state+' Đơn vị thụ hưởng thành công');
        this.SupportedPeoples = result.data as SupportedPeople[];
      }    
    }
    catch (e) {
      alert(state+' Đơn vị thụ hưởng thất bại');
    }
  };


  public deleteSupportedPeople = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá Đơn vị thụ hưởng này?')){
        const result = await this.SupportedPeopleService.deleteSupportedPeople(id);
        if (result)
        {
          this.notificationService.warn('Xoá Đơn vị thụ hưởng thành công');
          this.SupportedPeoples = result.data as SupportedPeople[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}

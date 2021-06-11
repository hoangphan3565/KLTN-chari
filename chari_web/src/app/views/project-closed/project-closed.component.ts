import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import * as XLSX from 'xlsx';
import { DonateDetailsService } from '../../services/donate-details.service';
import { DonateDetail } from '../../models/DonateDetail';

@Component({
  templateUrl: './project-closed.component.html',
})
export class ProjectClosedComponent implements OnInit {
  Projects: any[];
  data: [][];
  DonateDetail: DonateDetail;

  constructor(
    private ProjectService: ProjectService,
    private DonateDetailsService: DonateDetailsService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getClosed()
  }

  async getClosed(){
    this.Projects = await this.ProjectService.getClosed() as any[];
  }

  async updateMoveMoneyProgress(){
    const result = await this.ProjectService.updateMoveMoneyProgress() as any[];
    if (result)
      {
        this.notificationService.success(' Cập nhật thành công');
        this.Projects = result as any[];
      }   
  }
  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    });
  }

  onFileChange(evt: any) {
    const target : DataTransfer =  <DataTransfer>(evt.target);
    if (target.files.length !== 1) throw new Error('Cannot use multiple files');
    const reader: FileReader = new FileReader();
    reader.onload = (e: any) =>  {
      const bstr: string = e.target.result;
      var wb: XLSX.WorkBook = XLSX.read(bstr, { type: 'binary' });
      
      wb.SheetNames.forEach(sheet => {
        let rowObject = XLSX.utils.sheet_to_json(wb.Sheets[sheet]);
        console.log(rowObject);
        this.saveDonateWithBankDetail(rowObject);
      })
    };
  
    reader.readAsBinaryString(target.files[0]);
  }

  public saveDonateWithBankDetail = async (data: any[]) => {
    try 
    {
      const result = await this.DonateDetailsService.saveDonateWithBankDetail(data);
      if (result==1)
      {
        this.notificationService.success('Cập nhật tiền quyên góp từ bảng sao kê thành công');
      }    
    }
    catch (e) {
      alert('Cập nhật tiền quyên góp từ bảng sao kê thất bại');
    }
  };
  
}


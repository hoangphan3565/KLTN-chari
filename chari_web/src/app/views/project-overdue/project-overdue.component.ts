import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { DonateDetail } from '../../models/DonateDetail';
import { DonateDetailsService } from '../../services/donate-details.service';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import { DialogExtendComponent } from './dialog-extend/dialog-extend.component';
import * as XLSX from 'xlsx';

@Component({
  templateUrl: './project-overdue.component.html',
})
export class ProjectOverdueComponent implements OnInit {
  Projects: Project[];
  data: [][];
  DonateDetail: DonateDetail;

  constructor(
    private ProjectService: ProjectService,
    private DonateDetailsService: DonateDetailsService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.getOverdue()
  }
  public async getOverdue(){
    this.Projects = await this.ProjectService.getOverdue() as Project[];
  }
  public closeProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự đóng dự án này?')){
        const result = await this.ProjectService.closeProject(id);
        if (result)
        {
          this.notificationService.warn('Đóng dự án thành công');
          this.Projects = result as Project[];
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
    dialogRef.afterClosed().subscribe((result: Number) => {
      if(result){
        this.extendProject(id,result);
      }
    });
  }
  
  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    });
  }

  public extendProject = async (id,nod) => {
    try 
    {
      const result = await this.ProjectService.extendProject(id,nod);
      if (result)
      {
        this.notificationService.warn('Gia hạn dự án thành công');
        this.Projects = result as any[];
      }  
    }
    catch (e) {
      console.log(e);
    }
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


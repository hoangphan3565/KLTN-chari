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
    this.Projects = await (await this.ProjectService.getOverdue()).data as Project[];
  }
  public closeProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự đóng dự án này?')){
        const result = await this.ProjectService.closeProject(id,0);
        if (result)
        {
          this.notificationService.warn('Đóng dự án thành công');
          this.Projects = result.data as Project[];
        }  
      }
    }
    catch (e) {
      this.notificationService.warn('Đóng dự án thất bại');
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
      const result = await this.ProjectService.extendProject(id,nod,0);
      if (result)
      {
        this.notificationService.warn('Gia hạn dự án thành công');
        this.Projects = result.data as any[];
      }  
    }
    catch (e) {
      this.notificationService.warn('Gia hạn dự án thất bại');
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
        this.disburseWithBank(rowObject);
      })
    };
  
    reader.readAsBinaryString(target.files[0]);
  }

  public disburseWithBank = async (data: any[]) => {
    try 
    {
      const result = await (await this.DonateDetailsService.disburseWithBank(data)).data;
      if(result)
      {
        this.notificationService.success(result.message);
        this.getOverdue();
      }
    }
    catch (e) {
      alert('Cập nhật giải ngân từ bảng sao kê thất bại');
    }
  };
}


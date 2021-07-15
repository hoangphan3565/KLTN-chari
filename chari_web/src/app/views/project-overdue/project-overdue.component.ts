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
  };

  public async getOverdue(){
    this.Projects = await (await this.ProjectService.getOverdue()).data as Project[];
  };

  public closeProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự đóng dự án này?')){
        const res = await (await this.ProjectService.closeProject(id,0)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.Projects = res.data as Project[];
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
    dialogRef.afterClosed().subscribe((res: Number) => {
      if(res){
        this.extendProject(id,res);
      }
    })
  }
  
  openDisburseDialog(data): void {
    const dialogRef = this.dialog.open(DialogDisburseProjectComponent, {
      width: '250px',
      data: data
    })
  }

  public extendProject = async (id,nod) => {
    try 
    {
      const res = await (await this.ProjectService.extendProject(id,nod,0)).data;
      if (res)
      {
        this.notificationService.warn(res.message);
        this.Projects = res.data as any[];
      }  
    }
    catch (e) {
      this.notificationService.warn('Gia hạn dự án thất bại');
      console.log(e);
    }
  }

  onFileChange(ev) {
    let workBook = null;
    let jsonData = null;
    const reader = new FileReader();
    const file = ev.target.files[0];
    reader.onload = (event) => {
      const data = reader.result;
      workBook = XLSX.read(data, { type: 'binary' });
      jsonData = workBook.SheetNames.reduce((initial, name) => {
        const sheet = workBook.Sheets[name];
        initial[name] = XLSX.utils.sheet_to_json(sheet);
        return initial;
      }, {});
      this.disburseWithBank(jsonData.Sheet1 as DonateDetail[]);
    }
    reader.readAsBinaryString(file);
  }

  public disburseWithBank = async (data: any[]) => {
    try 
    {
      const res = await (await this.DonateDetailsService.disburseWithBank(data)).data;
      if(res)
      {
        this.notificationService.success(res.message);
        this.getOverdue();
      }
    }
    catch (e) {
      alert('Cập nhật giải ngân từ bảng sao kê thất bại');
    }
  };
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  }
}


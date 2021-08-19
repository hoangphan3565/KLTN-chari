import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { DonateDetail } from '../../models/DonateDetail';
import { DonateDetailsService } from '../../services/donate-details.service';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { ProjectService } from '../../services/Project.service';
import { DialogDisburseProjectComponent } from './dialog-disburse-project/dialog-disburse-project.component';
import * as XLSX from 'xlsx';
import { DialogExtendComponent } from './dialog-extend/dialog-extend.component';

@Component({
  templateUrl: './project-overdue.component.html',
})
export class ProjectOverdueComponent implements OnInit {
  Projects: Project[];
  data: [][];
  DonateDetail: DonateDetail;

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

  constructor(
    private projectService: ProjectService,
    private DonateDetailsService: DonateDetailsService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.countTotal();
    this.getList(1,this.itemsPerPage);
  }


  public async countTotal(){
    this.totalItems = await (await this.projectService.countOverdueProjects()).data;
  }

  public async getList(a,b){
    this.Projects = await (await this.projectService.getOverdueProjects(a,b)).data as Project[];
  } 


  public closeProject = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự đóng dự án này?')){
        const res = await (await this.projectService.closeProject(id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getList(this.currentPage,this.itemsPerPage);
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
      data: data as Project
    })
  }

  public extendProject = async (id,nod) => {
    try 
    {
      const res = await (await this.projectService.extendProject(id,nod)).data;
      if (res)
      {
        this.notificationService.warn(res.message);
        this.getList(this.currentPage,this.itemsPerPage);
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
    if (ev.target.files.length > 1) {
      this.notificationService.success('Chỉ được chọn 1 file');
      return;
    }
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
        this.getList(this.currentPage,this.itemsPerPage);
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


import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { SupportedPeople } from '../../models/SupportedPeople';
import { NotificationService } from '../../services/notification.service';
import { SupportedPeopleService } from '../../services/supported-people.service';
import { DialogSupportedPeopleComponent } from './dialog-supported-people/dialog-supported-people.component';
import Cookies from 'js-cookie'
import { Project } from '../../models/Project';
import { ProjectService } from '../../services/Project.service';
import { DialogProjectAddComponent } from './dialog-project/dialog-project.component';
@Component({
  selector: 'app-supported-people',
  templateUrl: './supported-people.component.html',
})
export class SupportedPeopleComponent implements OnInit {

  SupportedPeoples: SupportedPeople[];
  SupportedPeople: SupportedPeople;
  Project: Project;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number;
  currentPage: number = 1;
  
  pageChanged(event: any): void {
    this.currentPage =  event.page;
    this.getSupportedPeople(this.currentPage,this.itemsPerPage);
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
    this.getSupportedPeople(this.currentPage,this.itemsPerPage);
  }

  clb_id: Number;
  constructor(
    private SupportedPeopleService: SupportedPeopleService,
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.clb_id = JSON.parse(Cookies.get("loginInfo")).info.clb_ID;
    this.itemsPerPage=5;
    this.getTotalSupportedPeoples();
    this.getSupportedPeople(1,this.itemsPerPage)  }


  public async getTotalSupportedPeoples(){
    this.totalItems = await (await this.SupportedPeopleService.countTotal(this.clb_id)).data;
  }

  public async getSupportedPeople(a,b){
    this.SupportedPeoples = await (await this.SupportedPeopleService.getSupportedPeoples(this.clb_id,a,b)).data as SupportedPeople[];
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogSupportedPeopleComponent, {
      width: '350px',
      data: this.SupportedPeople
    });
    dialogRef.afterClosed().subscribe((res: SupportedPeople) => {
      if(res){
        this.saveSupportedPeople(res)     
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
  public saveSupportedPeople = async (data) => {
    try 
    {
      const res = await (await this.SupportedPeopleService.saveSupportedPeople(data,this.clb_id)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getSupportedPeople(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      console.log(e);
    }
  };


  public deleteSupportedPeople = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá Người thụ hưởng này?')){
        const res = await (await this.SupportedPeopleService.deleteSupportedPeople(id,this.clb_id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getSupportedPeople(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

  openProjectDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectAddComponent, {
      width: '900px',
      data: this.Project,
    });
    dialogRef.afterClosed().subscribe((res) => {
      if(res){
        this.ceateProject(res);
      }
    });
  }

  openAddProjectDialog(sp): void {
    this.Project = {
      prj_ID:null,
      projectName:'',
      briefDescription:'',
      description:'',
      imageUrl:'',
      videoUrl:'',
      startDate:'',
      endDate:'',
      targetMoney:'',
      canDisburseWhenOverdue:true,
      prt_ID:null,
      projectType:null,      
      cti_ID:null,
      city:null,
      stp_ID:sp.stp_ID,
      supportedPeople:sp,      
      images:[]
    }; 
    this.openProjectDialog();
  }
  public ceateProject = async (data) => {
    try 
    {
      const res = await this.ProjectService.createProject(data,0);
      if (res)
      {
        this.notificationService.success('Thêm dự án từ thiện thành công');
      }    
    }
    catch (e) {
      this.notificationService.warn('Thêm dự án từ thiện thất bại');
    }
  };  
}

import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { SupportedPeopleRecommend } from '../../models/SupportedPeopleRecommend';
import { NotificationService } from '../../services/notification.service';
import Cookies from 'js-cookie'
import { Project } from '../../models/Project';
import { ProjectService } from '../../services/Project.service';
import { DialogProjectAddComponent } from './dialog-project/dialog-project.component';
import { DialogSupportedPeopleRecommendComponent } from './dialog-supported-people-recommend/dialog-supported-people-recommend.component';
import { SupportedPeopleRecommendService } from '../../services/supported-people-recommend.service';

@Component({
  selector: 'app-supported-people-recommend',
  templateUrl: './supported-people-recommend.component.html',
})
export class SupportedPeopleRecommendComponent implements OnInit {

  SupportedPeopleRecommends: any[];
  SupportedPeopleRecommend: SupportedPeopleRecommend;
  Project: Project;

  maxSize: number = 5;
  totalItems: number;
  itemsPerPage: number;
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
    private SupportedPeopleRecommendService: SupportedPeopleRecommendService,
    private ProjectService: ProjectService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.itemsPerPage=5;
    this.countAll();
    this.getList(1,this.itemsPerPage)  
  }


  public async countAll(){
    this.totalItems = await (await this.SupportedPeopleRecommendService.countAll()).data;
  }

  public async getList(a,b){
    this.SupportedPeopleRecommends = await (await this.SupportedPeopleRecommendService.getFromAtoB(a,b)).data as any[];
  }

  checkStatus = async (data) => {
    try
    {
      const res = await (await this.SupportedPeopleRecommendService.checkStatus(data.spr_ID,0)).data;
      if (res){
        if(res.errorCode==0){
          this.prepareData(res.data);
          this.openHandleDialog(this.SupportedPeopleRecommend);
        }else{
          this.notificationService.success(res.message);
        }
        this.getList(this.currentPage,this.itemsPerPage);
      }  
    }
    catch (e) {
      console.log(e);
    }
  }  
  
  prepareData(p: SupportedPeopleRecommend) {
    this.SupportedPeopleRecommend = {
      spd_ID: p.spd_ID,
      sprID: p.sprID,
      referrerName:p.referrerName,
      referrerPhone:p.referrerPhone,
      referrerDescription:p.referrerDescription,

      fullName:p.fullName,
      address:p.address,
      phoneNumber:p.phoneNumber,
      bankName:p.bankName,
      bankAccount:p.bankAccount,

      projectName:p.projectName,
      briefDescription:p.briefDescription,
      description:p.description,
      imageUrl:p.imageUrl,
      videoUrl:p.videoUrl,
      startDate:p.startDate,
      endDate:p.endDate,
      targetMoney:p.targetMoney,
      canDisburseWhenOverdue:p.canDisburseWhenOverdue,
      prt_ID:p.prt_ID,
      projectType:p.projectType,
      cti_ID:p.cti_ID,
      city:p.city,
      images:p.images,
      clb_ID: 0,
    }; 
  }

  openHandleDialog(p: SupportedPeopleRecommend): void {
    const dialogRef = this.dialog.open(DialogSupportedPeopleRecommendComponent, {
      width: '500px',
      data: p
    });
    dialogRef.afterClosed().subscribe((res: SupportedPeopleRecommend) => {
      if(res){
        this.openHandleStep2Dialog(res);
      }
      this.getList(this.currentPage,this.itemsPerPage);
    });
  }


  openHandleStep2Dialog(p: SupportedPeopleRecommend): void {
    const dialogRef = this.dialog.open(DialogProjectAddComponent, {
      width: '800px',
      data: p
    });
    dialogRef.afterClosed().subscribe((res: any) => {
      if(res){
        if(res=='back'){
          this.openHandleDialog(this.SupportedPeopleRecommend);
        }else{
          this.createProject(res);
        }
      }
    });
  }


  public createProject = async (data) => {
    try 
    {
      const res = await (await this.SupportedPeopleRecommendService.createProject(data)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getList(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      console.log(e);
    }
  };


  public delete = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá hoàn cảnh?')){
        const res = await (await this.SupportedPeopleRecommendService.delete(id)).data;
        if (res)
        {
          this.notificationService.warn(res.message);
          this.getList(this.currentPage,this.itemsPerPage);
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }
}

import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ProjectType } from '../../models/ProjectType';
import { NotificationService } from '../../services/notification.service';
import { ProjectTypeService } from '../../services/project-type.service';
import { DialogProjectTypeComponent } from './dialog-project-type/dialog-project-type.component';

@Component({
  selector: 'app-project-type',
  templateUrl: './project-type.component.html',
})
export class ProjectTypeComponent implements OnInit {
  projectTypes: ProjectType[];
  projectType: ProjectType;
  isEdit: boolean=false;

  constructor(
    private projectTypeService: ProjectTypeService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }


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


  ngOnInit(): void {
    this.countTotal();
    this.getList(1,this.itemsPerPage)
  }
  public async countTotal(){
    this.totalItems = await (await this.projectTypeService.countTotal()).data;
  }
  public async getList(a,b){
    this.projectTypes = await (await this.projectTypeService.getPerPage(a,b)).data as ProjectType[];
  }


  public async getProjectType(){
    this.projectTypes = await (await this.projectTypeService.getProjectTypes()).data as ProjectType[];
  }

  getID(data){
    console.log(data.prt_ID);
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectTypeComponent, {
      width: '500px',
      data: this.projectType,
    });
    dialogRef.afterClosed().subscribe((res: ProjectType) => {
      if(res){
        if (res.prt_ID==null) {
          this.saveProjectType(res,'Thêm');
        }else{
          this.saveProjectType(res,'Cập nhật');
        }
      }
    });
  }

  openEditDialog(pt : ProjectType): void {
    this.projectType = {
      prt_ID:pt.prt_ID,
      projectTypeName:pt.projectTypeName,
      description:pt.description,
      canDisburseWhenOverdue:pt.canDisburseWhenOverdue,
      imageUrl:pt.imageUrl
    }
    this.isEdit=true;
    this.openDialog();
  }

  saveProjectType = async (project,state) => {
    try 
    {
      const res = await this.projectTypeService.saveProjectType(project);
      if (res)
      {
        this.notificationService.success(state+' Gói từ thiện thành công');
        this.projectTypes = res.data as ProjectType[];
      }    
    }
    catch (e) {
      alert(state+' Gói từ thiện thất bại');
    }
  };


  deleteProjectType = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá Gói từ thiện này?')){
        const res = await this.projectTypeService.deleteProjectType(id);
        if (res)
        {
          this.notificationService.warn('Xoá Gói từ thiện thành công');
          this.projectTypes = res.data as ProjectType[];
        }  
      }
    }
    catch (e) {
      console.log(e);
    }
  }

  clearData(){
    this.projectType = new ProjectType;
    this.projectType.prt_ID=null;
    this.projectType.description=null;
    this.projectType.imageUrl=null;
    this.projectType.canDisburseWhenOverdue=true;
  }

  onFileChange(evt: any) {
    const target : DataTransfer =  <DataTransfer>(evt.target);
    if (target.files.length !== 1) throw new Error('Cannot use multiple files');

  }

}

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

  ngOnInit(): void {
    this.getProjectType()
  }
  public async getProjectType(){
    this.projectTypes = await this.projectTypeService.getProjectTypes() as ProjectType[];
  }

  getID(data){
    console.log(data.prt_ID);
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectTypeComponent, {
      width: '250px',
      data: this.projectType,
    });
    dialogRef.afterClosed().subscribe((result: ProjectType) => {
      if (result.prt_ID==null) {
        this.saveProjectType(result,'Thêm');
      }else{
        this.saveProjectType(result,'Cập nhật');
      }
    });
  }

  openEditDialog(pt : ProjectType): void {
    this.projectType = {
      prt_ID:pt.prt_ID,
      projectTypeName:pt.projectTypeName
    }
    this.isEdit=true;
    this.openDialog();
  }

  saveProjectType = async (project,state) => {
    try 
    {
      const result = await this.projectTypeService.saveProjectType(project);
      if (result)
      {
        this.notificationService.success(state+' gói từ thiện thành công');
        this.projectTypes = result as ProjectType[];
      }    
    }
    catch (e) {
      alert(state+' gói từ thiện thất bại');
    }
  };


  deleteProjectType = async (id) => {
    try 
    {
      if(confirm('Bạn có thực sự muốn xoá gói từ thiện này?')){
        const result = await this.projectTypeService.deleteProjectType(id);
        if (result)
        {
          this.notificationService.warn('Xoá gói từ thiện thành công');
          this.projectTypes = result as ProjectType[];
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
  }

}

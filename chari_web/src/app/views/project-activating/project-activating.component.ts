import { Component, OnInit,Pipe } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Post } from '../../models/Post';
import { Project } from '../../models/Project';
import { NotificationService } from '../../services/notification.service';
import { PostService } from '../../services/Post.service';
import { ProjectService } from '../../services/Project.service';
import { DialogPostActivatingComponent } from './dialog-post/dialog-post.component';
import * as XLSX from 'xlsx';
import { DonateDetailsService } from '../../services/donate-details.service';
import { DonateDetail } from '../../models/DonateDetail';
import { DialogProjectComponent } from './dialog-project/dialog-project.component';

@Component({
  templateUrl: './project-activating.component.html',
})
export class ProjectActivatingComponent implements OnInit {
  Projects: Project[];
  Project: Project;
  Post: Post;

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
  
  data: [][];
  DonateDetail: DonateDetail;

  constructor(
    private DonateDetailsService: DonateDetailsService,
    private projectService: ProjectService,
    private postService: PostService,
    private notificationService: NotificationService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    this.countTotal();
    this.getList(1,this.itemsPerPage);
  }


  public async countTotal(){
    this.totalItems = await (await this.projectService.countActivatingProjects()).data;
  }

  public async getList(a,b){
    this.Projects = await (await this.projectService.getActivatingProjects(a,b)).data as Project[];
  }  

  openDialog(): void {
    const dialogRef = this.dialog.open(DialogPostActivatingComponent, {
      width: '900px',
      data: this.Post,
    });
    dialogRef.afterClosed().subscribe((res: Post) => {
      if(res){
        this.savePost(res);
      }
    });
  }
  clearData(p:Project){
    this.Post = {
      pos_ID: null,
      name: '',
      content: '',
      projectId:p.prj_ID,
      projectName:p.projectName,
      isPublic: true,
      imageUrl: '',
      videoUrl: '',
      collaboratorId:0,
      images:[]
    };
  }

  public savePost = async (data) => {
    try 
    {
      const res = await this.postService.savePost(data,0);
      if (res)
      {
        this.notificationService.success('Thêm tin tức thành công');
      }    
    }
    catch (e) {
      alert('Thêm tin tức thất bại');
    }
  };  
  
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
      this.saveDonateWithBank(jsonData.Sheet1 as DonateDetail[]);
    }
    reader.readAsBinaryString(file);
  }

  public saveDonateWithBank = async (data: any[]) => {
    try 
    {
      const res = await (await this.DonateDetailsService.saveDonateWithBank(data)).data;
      if (res==1)
      {
        this.notificationService.success('Cập nhật tiền quyên góp từ bảng sao kê thành công');
        this.getList(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      alert('Cập nhật tiền quyên góp từ bảng sao kê thất bại');
    }
  };
  numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  };

  //==============================================================================================================================


  openProjectDialog(): void {
    const dialogRef = this.dialog.open(DialogProjectComponent, {
      width: '900px',
      data: this.Project,
    });
    dialogRef.afterClosed().subscribe((res) => {
      if(res){
        if (res.prj_ID==null) this.ceateProject(res);
        else this.updateProject(res);
      }
    });
  }
  openEditProjectDialog(p : Project): void {
    this.Project = {
      prj_ID:p.prj_ID,
      projectName:p.projectName,
      briefDescription:p.briefDescription,
      description:p.description,
      imageUrl:p.imageUrl,
      videoUrl:p.videoUrl,
      startDate:p.startDate,
      endDate:p.endDate,
      curMoney:p.curMoney,
      targetMoney:p.targetMoney,
      numOfPost:p.numOfPost,
      canDisburseWhenOverdue:p.projectType.canDisburseWhenOverdue,
      prt_ID:p.projectType.prt_ID,
      projectType:p.projectType,      
      cti_ID:p.city.cti_ID,
      city:p.city,
      stp_ID:p.supportedPeople.stp_ID,
      supportedPeople:p.supportedPeople,
      images:p.images
    }; 
    this.openProjectDialog();
  }
  openAddProjectDialog(){
    this.Project = {
      prj_ID:null,
      projectName:'',
      briefDescription:'',
      description:'',
      imageUrl:'',
      videoUrl:'',
      startDate:'',
      endDate:'',
      curMoney:'',
      targetMoney:'',
      numOfPost:0,
      canDisburseWhenOverdue:true,
      prt_ID:null,
      projectType:null,      
      cti_ID:null,
      city:null,
      stp_ID:null,
      supportedPeople:null,
      images:[]
    };
    this.openProjectDialog();
  }

  public ceateProject = async (data) => {
    try 
    {
      const res = await this.projectService.createProject(data,0);
      if (res)
      {
        this.notificationService.success('Thêm dự án từ thiện thành công');
        this.countTotal();
        this.getList(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      this.notificationService.warn('Thêm dự án từ thiện thất bại');
    }
  };  

  public updateProject = async (data) => {
    try 
    {
      const res = await (await this.projectService.updateProject(data)).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getList(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      this.notificationService.warn('Cập nhật thất bại');
    }
  };  
  
  public disburseFund = async () => {
    try 
    {
      const res = await (await this.projectService.disburseFund()).data;
      if (res)
      {
        this.notificationService.success(res.message);
        this.getList(this.currentPage,this.itemsPerPage);
      }    
    }
    catch (e) {
      this.notificationService.warn('Đã có lỗi xảy ra');
    }
  };
  
  async updateMoveMoneyProgress(){
    await this.projectService.updateMoveMoneyProgress();
    this.getList(this.currentPage,this.itemsPerPage); 
  };

}

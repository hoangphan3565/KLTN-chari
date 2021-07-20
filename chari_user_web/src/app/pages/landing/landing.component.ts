import { Component, OnInit } from '@angular/core';
import { RecommendInfo } from '../../models/RecommendInfo';
import { NotificationService } from '../../services/notification.service';
import { SupportedPeopleRecommendService } from '../../services/supported-people-recommend.service';

@Component({
  selector: 'app-landing',
  templateUrl: './landing.component.html',
  styleUrls: ['./landing.component.css']
})
export class LandingComponent implements OnInit {
  data: RecommendInfo;

  constructor(
    private notificationService: NotificationService,
    private service: SupportedPeopleRecommendService,
  ) { }

  ngOnInit(): void {
    this.data = {
      referrerName:"",
      referrerPhone:"",
      referrerDescription:"",
      fullName:"",
      address:"",
      phoneNumber:"",
      bankName:"",
      bankAccount:"",
      status:"PENDING",
    };  
  }

  getreferrerName(data){
    this.data.referrerName=data;
  }
  getreferrerPhone(data){
    this.data.referrerPhone=data;
  }
  getreferrerDescription(data){
    this.data.referrerDescription=data;
  }
  getfullName(data){
    this.data.fullName=data;
  }
  getaddress(data){
    this.data.address=data;
  }
  getphoneNumber(data){
    this.data.phoneNumber=data;
  }
  getbankName(data){
    this.data.bankName=data;
  }
  getbankAccount(data){
    this.data.bankAccount=data;
  }

  async send() {
    console.log(this.data);
    if(this.data.referrerName==""||this.data.referrerPhone==""||this.data.referrerDescription==""||this.data.fullName==""||this.data.address==""){
      this.notificationService.warn("Hãy điền những thông tin có dấu *");
    }else{
      try {
        const res = await (await this.service.sendInfo(this.data)).data as any;
        if(res){
          this.notificationService.warn(res.message);
        }
      }catch(e){
        this.notificationService.warn('Đã có lỗi xảy ra!');
      }
    }
  }
}

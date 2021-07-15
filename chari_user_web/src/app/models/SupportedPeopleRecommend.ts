import { City } from "./City";
import { ProjectType } from "./ProjectType";
import { SupportedPeople } from "./SupportedPeople";

export class SupportedPeopleRecommend {
    spd_ID: number;
    sprID: number;

    referrerName:string;
    referrerPhone:string;
    referrerDescription:string;

    fullName:string;
    address:string;
    phoneNumber:string;
    bankName:string;
    bankAccount:string;

    projectName:string;
    briefDescription:string;
    description:string;
    startDate:string;
    endDate:string;
    targetMoney:string;
    videoUrl:string;
    imageUrl:string;
    images:string[];
    canDisburseWhenOverdue:boolean;
    prt_ID:Number;
    projectType:ProjectType;
    cti_ID:Number;
    city:City;
    clb_ID: Number;
}
import { City } from "./City";
import { Collaborator } from "./Collaborator";
import { ProjectType } from "./ProjectType";
import { SupportedPeople } from "./SupportedPeople";

export class Project {
    prj_ID: Number;
    projectName:string;
    briefDescription:string;
    description:string;
    startDate:string;
    endDate:string;
    curMoney:string;
    targetMoney:string;
    videoUrl:string;
    imageUrl:string;
    images:string[];
    canDisburseWhenOverdue:boolean;
    prt_ID:Number;
    projectType:ProjectType;    
    stp_ID:Number;
    supportedPeople:SupportedPeople;
    cti_ID:Number;
    city:City;
}
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
    targetMoney:string;
    videoUrl:string;
    imageUrl:string;
    images:string[];
    prt_ID:Number;
    projectType:ProjectType;
    stp_ID:Number;
    supportedPeople:SupportedPeople;
    // clb_ID:Number;
    // collaborator:Collaborator;
}
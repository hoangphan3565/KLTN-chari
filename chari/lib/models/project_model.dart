import 'package:chari/models/models.dart';

class Project {
  int prj_id;
  String project_code;
  String project_name;
  String brief_description;
  String description;
  String image_url;
  String video_url;
  int target_money;
  int cur_money;
  int num_of_donations;
  int remaining_term;
  int prt_id;
  String project_type_name;
  String project_type_image_url;
  int clb_id;
  String collaborator_name;
  String status;
  List<dynamic> imgList;

  Project(this.prj_id, this.project_name, this.brief_description,this.description,
      this.image_url,this.video_url,this.imgList,this.cur_money,this.target_money,this.num_of_donations,
      this.remaining_term,this.prt_id, this.project_type_name,this.project_type_image_url,
      this.clb_id,this.collaborator_name, this.status, ) {}




  Project.fromJson(Map json)
      : prj_id = json['prj_ID'],
        project_name = json['projectName'],
        brief_description = json['briefDescription'],
        description = json['description'],
        image_url = json['imageUrl'],
        video_url = json['videoUrl'],
        imgList = json['images'],
        cur_money = json['curMoney'],
        target_money = json['targetMoney'],
        num_of_donations = json['numOfDonations'],
        remaining_term = json['remainingTerm'],
        prt_id = json['prt_ID'],
        project_type_name=json['projectType']['projectTypeName'],
        project_type_image_url=json['projectType']['imageUrl'],
        clb_id =  json['clb_ID'],
        collaborator_name =  json['collaborator']['fullName'],
        status = json['status'];

}
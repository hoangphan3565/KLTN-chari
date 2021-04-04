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
  String status;
  List<String> imgList;

  Project(int prj_id, String project_name, String brief_description,String description,String image_url,String video_url,int cur_money,int target_money,int num_of_donations,int remaining_term,int prt_id, String project_type_name, String status, List<String> imgList) {
    this.prj_id = prj_id;
    this.project_name = project_name;
    this.brief_description = brief_description;
    this.description = description;
    this.image_url = image_url;
    this.video_url = video_url;
    this.cur_money = cur_money;
    this.target_money = target_money;
    this.num_of_donations = num_of_donations;
    this.remaining_term = remaining_term;
    this.prt_id = prj_id;
    this.project_type_name=project_type_name;
    this.status=status;
    this.imgList = imgList;
  }

  Project.fromJson(Map json)
      : prj_id = json['prj_id'],
        project_name = json['project_name'],
        brief_description = json['brief_description'],
        description = json['description'],
        image_url = json['image_url'],
        video_url = json['video_url'],
        cur_money = json['cur_money'],
        target_money = json['target_money'],
        num_of_donations = json['num_of_donations'],
        remaining_term = json['remaining_term'],
        prt_id = json['prt_id'],
        status = json['status'],
        project_type_name=json['project_type_name'];

}
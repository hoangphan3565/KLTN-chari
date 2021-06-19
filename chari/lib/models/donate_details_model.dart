class DonateDetails {
  String money;
  String donate_date;
  int project_id;
  String project_name;
  String project_image;
  String status;

  DonateDetails(this.money, this.donate_date,this.project_id, this.project_name,this.project_image,this.status) {}

  DonateDetails.fromJson(Map json)
      : money = json['money'].toString(),
        donate_date = json['donate_date'],
        project_id = json['project_id'],
        status = json['status'],
        project_image = json['project_image'],
        project_name = json['project_name'];
}
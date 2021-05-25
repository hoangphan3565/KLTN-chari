class DonateDetails {
  String money;
  String donate_date;
  int project_id;
  String project_name;
  String status;

  DonateDetails(this.money, this.donate_date,this.project_id, this.project_name,this.status) {}

  DonateDetails.fromJson(Map json)
      : money = json['money'].toString(),
        donate_date = json['donate_date'],
        project_id = json['project_id'],
        status = json['status'],
        project_name = json['project_name'];
}
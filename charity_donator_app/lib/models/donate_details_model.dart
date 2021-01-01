class DonateDetails {
  String money;
  String donate_date;
  int project_id;
  String project_name;

  DonateDetails(String money, String donate_date,int project_id, String project_name) {
    this.money = money;
    this.donate_date = donate_date;
    this.project_id = project_id;
    this.project_name = project_name;
  }

  DonateDetails.fromJson(Map json)
      : money = json['money'].toString(),
        donate_date = json['donate_date'],
        project_id = json['project_id'],
        project_name = json['project_name'];

}
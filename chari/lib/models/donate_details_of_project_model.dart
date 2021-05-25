class DonateDetailsOfProject {
  String money;
  String donator_name;
  String phone;
  String donate_date;
  String status;

  DonateDetailsOfProject(this.money,this.donator_name,this.phone,this.donate_date,this.status) {}

  DonateDetailsOfProject.fromJson(Map json)
      : money = json['money'].toString(),
        donator_name = json['donator_name'],
        phone = json['phone'],
        status = json['status'],
        donate_date = json['donate_date'];
}
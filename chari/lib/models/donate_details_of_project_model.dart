class DonateDetailsOfProject {
  String money;
  String donator_name;
  String message;
  String phone;
  String donate_date;

  DonateDetailsOfProject(this.money,this.donator_name,this.message,this.phone,this.donate_date) {}

  DonateDetailsOfProject.fromJson(Map json)
      : money = json['money'].toString(),
        donator_name = json['donator_name'],
        message = json['message'],
        phone = json['phone'],
        donate_date = json['donate_date'];
}
class DonatorNofitication {
  String title;
  String message;
  String date_time;
  int project_id;

  DonatorNofitication(this.title,this.message,this.date_time,this.project_id) {}

  DonatorNofitication.fromJson(Map json)
      : title = json['title'],
        message = json['message'],
        date_time = json['date_time'],
        project_id = json['project_id'];

}
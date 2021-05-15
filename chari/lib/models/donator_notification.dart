class DonatorNofitication {
  String topic;
  String title;
  String message;
  String create_time;
  int project_id;
  bool is_read;
  bool is_handled;

  DonatorNofitication(this.topic,this.title,this.message,this.create_time,this.project_id,this.is_read,this.is_handled) {}

  DonatorNofitication.fromJson(Map json)
      : topic = json['topic'],
        title = json['title'],
        message = json['message'],
        create_time = json['create_time'],
        project_id = json['project_id'],
        is_read = json['is_read'],
        is_handled = json['is_handled'];

}
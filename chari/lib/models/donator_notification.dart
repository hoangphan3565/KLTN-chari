class DonatorNotification {
  String topic;
  String title;
  String message;
  String create_time;
  int project_id;
  String project_image;
  bool read;
  bool handled;
  int total_money;

  DonatorNotification(this.topic,this.title,this.message,this.create_time,this.project_id,this.project_image,this.read,this.handled,this.total_money) {}

  DonatorNotification.fromJson(Map json)
      : topic = json['topic'],
        title = json['title'],
        message = json['message'],
        create_time = json['create_time'],
        project_id = json['project_id'],
        project_image = json['project_image'],
        read = json['read'],
        handled = json['handled'],
        total_money = json['total_money'];

}
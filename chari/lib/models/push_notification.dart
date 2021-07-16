class PushNotification {
  String topic;
  String title;
  String description;
  String message;
  int nof_ID;

  PushNotification(this.topic,this.title,this.description,this.message,this.nof_ID) {}

  PushNotification.fromJson(Map json)
      : topic = json['topic'],
        title = json['title'],
        description = json['description'],
        message = json['message'],
        nof_ID = json['nof_ID'];

}
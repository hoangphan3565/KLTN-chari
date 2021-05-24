class PushNotification {
  String topic;
  String title;
  String message;
  int nof_ID;

  PushNotification(this.topic,this.title,this.message,this.nof_ID) {}

  PushNotification.fromJson(Map json)
      : topic = json['topic'],
        title = json['title'],
        message = json['message'],
        nof_ID = json['nof_ID'];

}
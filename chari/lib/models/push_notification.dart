class PushNofitication {
  String topic;
  String title;
  String message;
  int nof_ID;

  PushNofitication(this.topic,this.title,this.message,this.nof_ID) {}

  PushNofitication.fromJson(Map json)
      : topic = json['topic'],
        title = json['title'],
        message = json['message'],
        nof_ID = json['nof_ID'];

}
class Donator {
  int id;
  String full_name;
  String address;
  String phone_number;
  String avatar_url;
  String favorite_project;
  String favorite_notification;

  Donator(this.id, this.full_name,this.address, this.phone_number,this.avatar_url,this.favorite_project,this.favorite_notification) {}

  Donator.fromJson(Map json)
      : id = json['dnt_ID'],
        full_name = json['fullName'],
        address = json['address'],
        phone_number = json['phoneNumber'],
        avatar_url = json['avatarUrl'],
        favorite_project = json['favoriteProject'],
        favorite_notification = json['favoriteNotification'];

}

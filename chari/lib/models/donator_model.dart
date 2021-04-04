class Donator {
  int id;
  String full_name;
  String address;
  String phone_number;
  String avatar_url;
  String favorite_project;

  Donator(int id, String full_name,String address, String phone_number,String avatar_url,String favorite_project) {
    this.id = id;
    this.full_name = full_name;
    this.address = address;
    this.phone_number = phone_number;
    this.avatar_url = avatar_url;
    this.favorite_project = favorite_project;
  }

  Donator.fromJson(Map json)
      : id = json['dnt_ID'],
        full_name = json['fullName'],
        address = json['address'],
        phone_number = json['phoneNumber'],
        avatar_url = json['avatarUrl'],
        favorite_project = json['favoriteProject'];

  Map toJson() {
    return {
      'dnt_ID': id,
      'fullName': full_name,
      'address': address,
      'phoneNumber': phone_number,
      'avatarUrl': avatar_url,
      'favoriteProject': favorite_project,
    };
  }
}

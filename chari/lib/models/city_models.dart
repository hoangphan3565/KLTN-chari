class City {
  String name;
  dynamic id;

  City(this.name,this.id) {}

  City.fromJson(Map json)
      : name = json['name'],
        id = json['cti_ID'];
}
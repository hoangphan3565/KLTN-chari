class ProjectType {
  int id;
  String name;

  ProjectType(int id, String name) {
    this.id = id;
    this.name = name;
  }

  ProjectType.fromJson(Map json)
      : id = json['prt_ID'],
        name = json['projectTypeName'];
}

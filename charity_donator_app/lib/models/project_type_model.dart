class ProjectType {
  int id;
  String code;
  String name;

  ProjectType(int id, String code,String name) {
    this.id = id;
    this.code = code;
    this.name = name;
  }

  ProjectType.fromJson(Map json)
      : id = json['prt_ID'],
        code = json['projectTypeCode'],
        name = json['projectTypeName'];
}

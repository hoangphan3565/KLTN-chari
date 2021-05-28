class ProjectType {
  int id;
  String name;
  String description;
  String image_url;

  ProjectType(this.id, this.name,this.description,this.image_url) {}

  ProjectType.fromJson(Map json)
      : id = json['prt_ID'],
        name = json['projectTypeName'],
        description = json['description'],
        image_url = json['imageUrl'];
}

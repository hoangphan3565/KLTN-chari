
class Post {
  int pos_id;
  String post_name;
  String post_content;
  int projectId;
  String projectName;
  String image_url;
  String video_url;
  String collaborator_name;
  List<dynamic> imgList;

  Post(this.pos_id, this.post_name,this.post_content,this.projectId,this.projectName,this.image_url,this.video_url,this.collaborator_name,this.imgList ) {}




  Post.fromJson(Map json)
      : pos_id = json['pos_ID'],
        post_name = json['name'],
        post_content = json['content'],
        projectId = json['projectId'],
        projectName = json['projectName'],
        image_url = json['imageUrl'],
        video_url = json['videoUrl'],
        imgList = json['images'],
        collaborator_name =  json['collaboratorName'];

}
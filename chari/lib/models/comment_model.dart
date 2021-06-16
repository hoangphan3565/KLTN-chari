class Comment {
  String donator_name;
  String content;
  dynamic project_id;
  String comment_date;
  dynamic cmt_ID;

  Comment(this.donator_name,this.content,this.project_id,this.comment_date,this.cmt_ID) {}

  Comment.fromJson(Map json)
      : donator_name = json['donatorName'],
        content = json['content'],
        project_id = json['projectId'],
        comment_date = json['commentDate'],
        cmt_ID = json['cmt_ID'];
}
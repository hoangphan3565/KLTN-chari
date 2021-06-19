import 'dart:async';
import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static Future getCommentListByProjectId(int projectId) {
    var url = baseUrl + comments + "/project/"+projectId.toString();
    return http.get(url);
  }

  static Future saveComment(int projectId,String donatorName, String content) {
    final body = jsonEncode(<String, String>{
      "donatorName":donatorName,
      "content":content,
      "projectId": projectId.toString()
    });
    var url = baseUrl + comments + "/project/"+projectId.toString();
    return http.post(url,headers:header,body:body);
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;
class FeedbackService {
  static Future sendFeedback(String contributor,String username,String title,String description,String token) {
    var url = "$baseUrl$feedbacks";
    final body = jsonEncode(<String, String>{
      "contributor":contributor,
      "title":title,
      "description":description,
      "username":username,
      "isReply":"false"
    });
    return http.post(url,headers:getHeaderJWT(token),body: body);
  }
}
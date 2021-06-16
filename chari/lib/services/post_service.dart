import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chari/services/services.dart';
class PostService {
  static Future getPost() {
    var url = baseUrl + posts;
    return http.get(url);
  }
}
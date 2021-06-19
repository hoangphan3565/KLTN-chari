import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;
class PostService {
  static Future getPost() {
    var url = baseUrl + posts +'/public';
    return http.get(url);
  }
  static Future getTotalPost() {
    var url = baseUrl + posts+'/public/count';
    return http.get(url);
  }

  static Future getPostsFromAToB(int a,int b) {
    var url = baseUrl + posts+'/public/from/'+a.toString()+'/to/'+b.toString();
    return http.get(url);
  }
}
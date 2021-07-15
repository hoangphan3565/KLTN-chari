import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;
class PostService {

  static Future getTotalFoundPost(String name) {
    var url = "$baseUrl$posts/public/find/$name/count";
    return http.get(url);
  }

  static Future findPostsPageASizeByName(String name,int a,int b) {
    var url = "$baseUrl$posts/public/find/$name/page/$a/size/$b";
    return http.get(url);
  }
}
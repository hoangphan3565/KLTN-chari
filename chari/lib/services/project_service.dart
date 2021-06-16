import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chari/services/services.dart';

class ProjectService {
  static Future getProjects() {
    var url = baseUrl + projects;
    return http.get(url);
  }

  static Future getProjectTypes() {
    var url = baseUrl + project_types;
    return http.get(url);
  }

  static Future getProjectReadyToMoveMoney(int money,String token) {
    var url = baseUrl + projects +'/ready_to_move_money/'+money.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }

}
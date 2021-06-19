import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class ProjectService {

  static Future getTotalProjects() {
    var url = baseUrl + projects+'/count';
    return http.get(url);
  }

  static Future getProjectById(int id) {
    var url = baseUrl + projects+'/'+id.toString();
    return http.get(url);
  }

  static Future getProjectsFromAToB(int a,int b) {
    var url = baseUrl + projects+'/from/'+a.toString()+'/to/'+b.toString();
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
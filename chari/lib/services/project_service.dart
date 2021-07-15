import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class ProjectService {

  static Future getTotalProjects() {
    var url = "$baseUrl$projects/count";
    return http.get(url);
  }

  static Future getProjectById(int id) {
    var url = "$baseUrl$projects/$id";
    return http.get(url);
  }


  static Future getProjectTypes() {
    var url = "$baseUrl$project_types";
    return http.get(url);
  }

  static Future getProjectReadyToMoveMoney(int money,String token) {
    var url = "$baseUrl$projects/ready_to_move_money/$money";
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future getProjectByFilterAndSearchKey(dynamic did,dynamic cids,dynamic ptids,dynamic status,String skey, int p,int s) {
    var url = "$baseUrl$projects/filter/favorite/donator/$did/city/$cids/project_type/$ptids/status/$status/find/$skey/page/$p/size/$s";
    return http.get(url);
  }

  static Future countTotalProjectsByMultiFilterAndSearchKey(dynamic did,dynamic cids,dynamic ptids,dynamic status,String skey) {
    var url = "$baseUrl$projects/filter/favorite/donator/$did/city/$cids/project_type/$ptids/status/$status/find/$skey/count";
    return http.get(url);
  }
}
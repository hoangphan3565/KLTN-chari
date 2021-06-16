import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chari/services/services.dart';

class DonateDetailsService {
  static Future getTotalDonateDetailsListByDonatorId(int donator_id,String token) {
    var url = baseUrl + donate_details+'/donator/'+donator_id.toString()+'/count';
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getDonateDetailsListByDonatorIdFromAToB(int donator_id,int a,int b,String token) {
    var url = baseUrl + donate_details+'/donator/'+donator_id.toString()+'/from/'+a.toString()+'/to/'+b.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future getDonateDetailsByProjectId(int project_id) {
    var url = baseUrl + donate_details+'/project/'+project_id.toString();
    return http.get(url);
  }
}
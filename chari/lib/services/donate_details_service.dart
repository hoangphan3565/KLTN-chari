import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class DonateDetailsService {
  static Future getTotalDonateDetailsListByDonatorId(String name,int donator_id,String token) {
    var url = "$baseUrl$donate_details/donator/$donator_id/find/$name/count";
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getDonateDetailsListByDonatorIdPageASizeB(String name,int donator_id,int a,int b,String token) {
    var url = "$baseUrl$donate_details/donator/$donator_id/find/$name/page/$a/size/$b";
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future getDonateDetailsByProjectId(int project_id) {
    var url = "$baseUrl$donate_details/project/$project_id";
    return http.get(url);
  }
}
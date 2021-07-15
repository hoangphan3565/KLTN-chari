import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class DonatorNotificationService {

  static Future getTotalDonatorNotificationByDonatorId(String skey,int donator_id,String token) {
    var url = "$baseUrl$donator_notifications/donator/$donator_id/find/$skey/count";
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getDonatorNotificationListByDonatorIdPageASizeB(String skey,int donator_id,int a,int b,String token) {
    var url = "$baseUrl$donator_notifications/donator/$donator_id/find/$skey/page/$a/size/$b";
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future putReadDonatorNotificationsByDonatorId(int donator_id,String token) {
    var url = "$baseUrl$donator_notifications/read/donator/$donator_id";
    return http.put(url,headers:getHeaderJWT(token));
  }
  static Future getCheckNewDonatorNotificationsByDonatorId(int donator_id,String token) {
    var url = "$baseUrl$donator_notifications/check_new/donator/$donator_id";
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getPushNotification(String token) {
    var url = "$baseUrl$push_notifications";
    return http.get(url,headers:getHeaderJWT(token));
  }
}
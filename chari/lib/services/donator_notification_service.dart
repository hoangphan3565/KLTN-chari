import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class DonatorNotificationService {
  static Future getDonatorNotificationListByDonatorId(int donator_id,String token) {
    var url = baseUrl + donator_notifications+'/donator/'+donator_id.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getTotalDonatorNotificationByDonatorId(int donator_id,String token) {
    var url = baseUrl + donator_notifications+'/donator/'+donator_id.toString()+'/count';
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getDonatorNotificationListByDonatorIdFromAToB(int donator_id,int a,int b,String token) {
    var url = baseUrl + donator_notifications+'/donator/'+donator_id.toString()+'/from/'+a.toString()+'/to/'+b.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future putReadDonatorNotificationsByDonatorId(int donator_id,String token) {
    var url = baseUrl + donator_notifications+'/read/donator/'+donator_id.toString();
    return http.put(url,headers:getHeaderJWT(token));
  }
  static Future getCheckNewDonatorNotificationsByDonatorId(int donator_id,String token) {
    var url = baseUrl + donator_notifications+'/check_new/donator/'+donator_id.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }
  static Future getPushNotification() {
    var url = baseUrl + push_notifications;
    return http.get(url);
  }
}
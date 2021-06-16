import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chari/services/services.dart';

class DonatorService {
  static Future postAddProjectToFavorite(int project_id,int donator_id,String token) {
    var url = baseUrl + donators + "/add_favorite/project/"+project_id.toString()+"/donator_id/"+donator_id.toString();
    return http.post(url,headers:getHeaderJWT(token));
  }

  static Future postRemoveProjectFromFavorite(int project_id,int donator_id,String token) {
    var url = baseUrl + donators + "/remove_favorite/project/"+project_id.toString()+"/donator_id/"+donator_id.toString();
    return http.post(url,headers:getHeaderJWT(token));
  }


  static Future putMoveMoney(int project_id,int donator_id,int target_project_id,int money,String token) {
    var url = baseUrl + donators + "/move_money/project/"+project_id.toString()+"/donator/"+donator_id.toString()+"/to_project/"+target_project_id.toString()+"/money/"+money.toString();
    return http.put(url,headers:getHeaderJWT(token));
  }

  static Future getFavoriteNotificationList(int donator_id,String token) {
    var url = baseUrl + donators+"/favorite_notification_list/"+donator_id.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future changeStateFavoriteNotificationList(int donator_id,int nof_id,bool value,String token) {
    var url = baseUrl + donators+"/change_state_notification_list/"+donator_id.toString()+"/nof_id/"+nof_id.toString()+"/value/"+value.toString();
    return http.put(url,headers:getHeaderJWT(token));
  }
}
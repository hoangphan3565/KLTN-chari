import 'dart:async';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class DonatorService {
  static Future postAddProjectToFavorite(int project_id,int donator_id,String token) {
    var url = "$baseUrl$donators/add_favorite/project/$project_id/donator/$donator_id";
    return http.post(url,headers:getHeaderJWT(token));
  }

  static Future postRemoveProjectFromFavorite(int project_id,int donator_id,String token) {
    var url = "$baseUrl$donators/remove_favorite/project/$project_id/donator/$donator_id";
    return http.post(url,headers:getHeaderJWT(token));
  }


  static Future putMoveMoney(int project_id,int donator_id,int target_project_id,int money,String token) {
    var url = "$baseUrl$donators/move_money/project/$project_id/donator/$donator_id/to_project/$target_project_id/money/$money";
    return http.put(url,headers:getHeaderJWT(token));
  }

  static Future getFavoriteNotificationList(int donator_id,String token) {
    var url = "$baseUrl$donators/favorite_notification_list/$donator_id";
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future changeStateFavoriteNotificationList(int donator_id,int nof_id,bool value,String token) {
    var url = "$baseUrl$donators/change_state_notification_list/$donator_id/nof_id/$nof_id/value/$value";
    return http.put(url,headers:getHeaderJWT(token));
  }
}
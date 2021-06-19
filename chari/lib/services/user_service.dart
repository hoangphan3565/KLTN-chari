
import 'dart:async';
import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:http/http.dart' as http;

class UserService{
  static signin(String username,String password) {
    String url = baseUrl+login;
    final body = jsonEncode(<String, String>{
      "username":username,
      "password":password,
    });
    return http.post(url,headers:header,body: body);
  }
  static loginFB(String name,String id) {
    String url = baseUrl+login_facebook;
    final body = jsonEncode(<String, String>{
      "name":name,
      "id":id,
      "usertype":"Donator"
    });
    return http.post(url,headers:header,body: body);
  }

  static signup(String username,String password1,String password2) {
    String url = baseUrl+register;
    final body = jsonEncode(<String, String>{
      "username":username,
      "password1":password1,
      "password2":password2,
      "usertype":"Donator"
    });
    return http.post(url,headers:header,body: body);
  }

  static Future activateUser(String username){
    String url = baseUrl+activate+"/"+username;
    http.post(url,headers:header);
  }

  static saveUser(String username) {
    String url = baseUrl+save_user;
    final body = jsonEncode(<String, String>{
      "username":username,
      "usertype":"Donator"
    });
    return http.post(url,headers:header,body: body);
  }
  static Future findUserByUserName(String username){
    var url = baseUrl + "/username/"+username;
    return http.get(url);
  }

  static Future deleteUserByUserName(String username){
    var url = baseUrl + "/username/"+username;
    return http.delete(url);
  }

  static Future saveFCMToken(String username,String fcmToken){
    String url = baseUrl+"/save_fcmtoken";
    final body = jsonEncode(<String, String>{
      "username":username,
      "fcmToken":fcmToken
    });
    return http.post(url,headers:header,body: body);
  }

  static Future changeUserPassword(String username,String new_password1,String new_password2){
    String url = baseUrl+"/change/password";
    final body = jsonEncode(<String, String>{
      "username":username,
      "password1":new_password1,
      "password2":new_password2,
      "usertype":"Donator"
    });
    return http.post(url,headers:header,body: body);
  }
}
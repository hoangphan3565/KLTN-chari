import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

//local ip và port server đang deploy
const baseUrl = "http://192.168.43.202:8080/api";
// const baseUrl = "http://172.20.10.2:8080/api";

const login = "/login";
const register = "/register";
const save_user = "/save_user";
const activate = "/activate";
const projects = "/projects";
const project_images = "/project_images/project/";
const donators = "/donators";
const donate_details = "/donate_details";
const project_types = "/project_types";

const header = {'Content-Type': 'application/json; charset=UTF-8',};
getHeaderJWT(token) {
  return {'Content-Type': 'application/json','Accept': 'application/json','Authorization': 'Bearer $token',};
}

class API {

  static signin(String username,String password) {
    String url = baseUrl+login;
    final body = jsonEncode(<String, String>{
      "username":username,
      "password":password,
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

  static Future getProjects() {
    var url = baseUrl + projects;
    return http.get(url);
  }
  static Future getProjectTypes() {
    var url = baseUrl + project_types;
    return http.get(url);
  }

  static Future getDonateDetailsListByDonatorId(int donator_id,String token) {
    var url = baseUrl + donate_details+'/donator_id/'+donator_id.toString();
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future getDonatorDetailsByPhone(String phone,String token) {
    var url = baseUrl + donators +'/phone/'+phone;
    return http.get(url,headers:getHeaderJWT(token));
  }

  static Future getImageByProjectID(int id) {
    var url = baseUrl + project_images + id.toString();
    return http.get(url);
  }

  static Future postAddProjectToFavorite(int project_id,int donator_id,String token) {
    var url = baseUrl + donators + "/add_favorite/project/"+project_id.toString()+"/donator_id/"+donator_id.toString();
    return http.post(url,headers:getHeaderJWT(token));
  }

  static Future postRemoveProjectFromFavorite(int project_id,int donator_id,String token) {
    var url = baseUrl + donators + "/remove_favorite/project/"+project_id.toString()+"/donator_id/"+donator_id.toString();
    return http.post(url,headers:getHeaderJWT(token));
  }
}
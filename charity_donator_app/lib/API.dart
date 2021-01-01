import 'dart:async';

import 'package:http/http.dart' as http;

//local ip và port server đang run
const baseUrl = "http://192.168.137.1:8080/api";
//const baseUrl = "http://192.168.43.139:8080/api";

const login = "/login";
const register = "/register";
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
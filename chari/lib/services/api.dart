
var baseUrl = 'http://192.168.1.13:8080/api';
// var baseUrl = 'https://b09350b55dd9.ngrok.io/api';

const login = '/login';
const login_facebook = '/login_facebook';
const register = '/register';
const save_user = '/save_user';
const activate = '/activate';
const projects = '/projects';
const comments = '/comments';
const posts = '/posts';
const cities = '/cities';
const donators = '/donators';
const donate_details = '/donate_details';
const donator_notifications = '/donator_notifications';
const push_notifications = '/push_notifications';
const project_types = '/project_types';
const feedbacks='/feedbacks';
const supported_people_recommends = '/supported_people_recommends';

const header = {'Content-Type': 'application/json; charset=UTF-8',};

getHeaderJWT(token) {
  return {'Content-Type': 'application/json; charset=UTF-8','Accept': 'application/json','Authorization': 'Bearer $token',};
}

setBaseUrl(String newBaseUrl) {
  baseUrl=newBaseUrl;
}


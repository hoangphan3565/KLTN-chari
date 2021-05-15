import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:chari/API.dart';
import 'package:chari/models/donator_notification.dart';
import 'package:chari/models/models.dart';
import 'package:chari/models/push_notification.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens.dart';

class AppBarScreen extends StatefulWidget {
  @override
  _AppBarScreenState createState() => _AppBarScreenState();
}

class _AppBarScreenState extends State<AppBarScreen> {
  StreamSubscription iosSubscription;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Timer _getNewDataAfter;
  int _page = 0;
  GlobalKey _bottomNavigationKeyUnLogged = GlobalKey();
  GlobalKey _bottomNavigationKeyLogged = GlobalKey();

  bool islogin = false;
  var projects = new List<Project>();
  var project_types = new List<ProjectType>();
  var donate_details_list = new List<DonateDetails>();
  var push_notification_list = new List<PushNofitication>();
  var donator_notification_list = new List<DonatorNofitication>();
  var donator = new Donator(null,null,null,null,null,null,null);

  List<String> listProjectIdFavorite = new List<String>();

  @override
  initState() {
    super.initState();
    _checkLogin();
    _getDatas();
    _getPushNotification();
    if(this.islogin==true){
      _getDonateHistory();
    }

    //Gọi API get dữ liệu để Cập nhật những thay đổi của các bài viết sau một khoảng thời gian
    _getNewDataAfter = Timer.periodic(Duration(seconds: 60), (Timer t) {
      setState(() {
        _getDatas();
        if(this.islogin==true){
          _getDonateHistory();
        }
        _checkLogin();
      });
    });

    _checkAndSubscribeFavoriteNotificationOfDonator();
    if(Platform.isIOS){
      iosSubscription = _fcm.onIosSettingsRegistered.listen((event) {_saveDeviceToken();});
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else { _saveDeviceToken();}
    _fcm.configure(
      onMessage: (Map<String,dynamic> message) async{
        print("onMessage: $message");
        Fluttertoast.showToast(
            msg: message['notification']['title']+": "+message['notification']['body'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
      onResume: (Map<String,dynamic> message) async{
        print("onResume: $message");
      },
      onLaunch: (Map<String,dynamic> message) async{
        print("onLaunch: $message");
      },
    );
  }

  @override
  dispose() {
    super.dispose();
    _getNewDataAfter.cancel();
  }


  _checkAndSubscribeFavoriteNotificationOfDonator() async {
    for(int i=0;i<push_notification_list.length;i++){
      _fcm.unsubscribeFromTopic(push_notification_list.elementAt(i).topic.toString());
    }
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String favorite_notification = _prefs.getString('donator_favorite_notification');
    for(int i=0;i<push_notification_list.length;i++){
      if(favorite_notification.contains(push_notification_list.elementAt(i).nof_ID.toString())){
        _fcm.subscribeToTopic(push_notification_list.elementAt(i).topic.toString());
      }
    }
  }

  _getPushNotification() async{
    API.getPushNotification().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        push_notification_list = list.map((model) => PushNofitication.fromJson(model)).toList();
      });
    });
  }

  _getDonateHistory() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int donator_id = _prefs.getInt('donator_id');
    String token = _prefs.getString('token');
    API.getDonateDetailsListByDonatorId(donator_id,token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        donate_details_list = list.map((model) => DonateDetails.fromJson(model)).toList();
      });
    });
  }

  _getNotification() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int donator_id = _prefs.getInt('donator_id');
    String token = _prefs.getString('token');
    API.getDonatorNotificationListByDonatorId(donator_id,token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        donator_notification_list = list.map((model) => DonatorNofitication.fromJson(model)).toList();
      });
    });
  }

  _getDatas() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String temp = _prefs.getString('donator_favorite_project');
    if(temp!=null){
      listProjectIdFavorite = temp.split(" ");
    }
    API.getProjects().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        projects = list.map((model) => Project.fromJson(model)).toList();
      });
      //Lấy dữ liệu hình ảnh của tất cả dự án
      for (int i = 0;i<projects.length;i++) {
        API.getImageByProjectID(projects[i].prj_id).then((response) {
          setState(() {
            List<String> imglist = (json.decode(response.body) as List<dynamic>).cast<String>();
            projects[i].imgList = imglist;
          });
        });
      }
    });
    API.getProjectTypes().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        project_types = list.map((model) => ProjectType.fromJson(model)).toList();
        project_types.insert(0, ProjectType(0, 'Tất cả dự án'));
      });
    });
  }

  _checkLogin() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    var now = new DateTime.now();

    setState(() {
      if(token==null || expirationDate.isBefore(now)) {
        islogin=false;
        prefs.clear();
      }
      else{
        islogin=true;
        donator.full_name = prefs.getString('donator_full_name').toString();
        donator.id = prefs.getInt('donator_id');
        donator.address = prefs.getString('donator_address').toString();
        donator.phone_number = prefs.getString('donator_phone').toString();
        donator.avatar_url = prefs.getString('donator_avatar_url').toString();
      }
    });
  }

  _saveDeviceToken() async{
    String fcmToken = await _fcm.getToken();
    if(islogin==true){
      API.saveFCMToken(this.donator.phone_number, fcmToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.islogin==false ?
    Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKeyUnLogged,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Cá nhân',
            ),
          ],
          currentIndex: _page,
          selectedItemColor: kPrimaryHighLightColor,
          onTap:  (index) {
              setState(() {
                _page = index;
              });
            },
        ),

        body: _page == 0 ? HomeScreen(projects: this.projects,project_types :this.project_types,isLogin: this.islogin,) : AskScreen()
    )
        :
    Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKeyLogged,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'Bản tin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Thông báo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Lịch sử',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Cá nhân',
            ),
          ],
          currentIndex: _page,
          selectedItemColor: kPrimaryHighLightColor,
          onTap: (index) {
            setState(() {
              if(index == 0){
                _getDatas();
                _checkAndSubscribeFavoriteNotificationOfDonator();
              }
              else if(islogin==true && index == 2){
                _getDatas();
                _getNotification();
                _getPushNotification();
                _checkAndSubscribeFavoriteNotificationOfDonator();
              }
              else if(islogin==true && index == 3){
                _getDonateHistory();
              }
              _page = index;
            });
          },
        ),
        body: (_page == 0 ? HomeScreen(projects: this.projects, project_types: this.project_types,isLogin: this.islogin)
            : _page == 1 ? Scaffold()
            : _page == 2 ? NotificationsScreen(donator_notification_list: this.donator_notification_list,projects: this.projects)
            : _page == 3 ? HistoryScreen(donate_details_list: this.donate_details_list,projects: this.projects)
            : PersonalScreen(donator: this.donator))
    );
  }
}



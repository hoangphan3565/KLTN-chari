import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:chari/models/donator_notification.dart';
import 'package:chari/models/models.dart';
import 'package:chari/models/push_notification.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/project_service.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:quiver/async.dart';
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
  bool isNewNotification = false;

  var projects = new List<Project>();
  int totalProject;
  var project_types = new List<ProjectType>();
  var posts = new List<Post>();
  int totalPost;
  var donate_details_list = new List<DonateDetails>();
  int totalDonate;
  var push_notification_list = new List<PushNotification>();
  var donator_notification_list = new List<DonatorNotification>();
  int totalNotification;
  var donator = new Donator(null,null,null,null,null,null,null,null,null);

  // List<String> listProjectIdFavorite = new List<String>();


  //Khi mở ứng dụng lên thì tất cả các widget sẽ được build ngay lập tức dữ liệu lấy từ API chậm hơn do đó biến isNewNotification vẫn là false
  //-> lợi dụng hàm CountdownTimer để gán lại biến isNewNotification
  int _start = 2;
  void getDataAfterBuildWidget() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );
    var sub = countDownTimer.listen(null);
    sub.onDone(() {
      if(this.islogin==true){
        _checkNewNotificationsByDonatorId();
      }
      sub.cancel();
    });
  }

  @override
  initState() {
    super.initState();
    _checkLogin();
    _getProject();
    _getProjectTypes();
    _getPosts();

    if(this.islogin==true){
      _checkNewNotificationsByDonatorId();
      _getDonateHistory();
      _getPushNotification();
      _checkAndSubscribeFavoriteNotificationOfDonator();
    }
    getDataAfterBuildWidget();

    //Gọi API get dữ liệu để Cập nhật những thay đổi của các bài viết sau một khoảng thời gian
    _getNewDataAfter = Timer.periodic(Duration(seconds: 60), (Timer t) {
      _getProject();
      _getProjectTypes();
      _getPosts();
      if(this.islogin==true){
        _checkNewNotificationsByDonatorId();
        _getDonateHistory();
        _getPushNotification();
        _checkAndSubscribeFavoriteNotificationOfDonator();
      }
      _checkLogin();
    });

  }

  @override
  dispose() {
    super.dispose();
    _getNewDataAfter.cancel();
  }

  _checkNewNotificationsByDonatorId() async {
    var res = await DonatorNotificationService.getCheckNewDonatorNotificationsByDonatorId(this.donator.id, this.donator.token);
    var jsRes = json.decode(utf8.decode(res.bodyBytes));
    setState(() {
      this.isNewNotification=jsRes;
    });
  }

  _checkAndSubscribeFavoriteNotificationOfDonator() async {
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String,dynamic> message) async{
        Fluttertoast.showToast(
            msg: message['notification']['title'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: kPrimaryHighLightColor,
            textColor: kPrimaryLightColor,
            fontSize: 16.0
        );
        setState(() {
          isNewNotification=true;
        });
      },
      onResume: (Map<String,dynamic> message) async{
        print("onResume: $message");
      },
      onLaunch: (Map<String,dynamic> message) async{
        print("onLaunch: $message");
      },
    );
    String favorite_notification = this.donator.favorite_notification;
    for(int i=0;i<push_notification_list.length;i++){
      if(favorite_notification.contains(push_notification_list.elementAt(i).nof_ID.toString())){
        _fcm.subscribeToTopic(push_notification_list.elementAt(i).topic.toString());
      }
    }
  }

  _getPushNotification() async{
    DonatorNotificationService.getPushNotification().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        push_notification_list = list.map((model) => PushNotification.fromJson(model)).toList();
      });
    });
  }


  _getDonateHistory() async{
    await DonateDetailsService.getTotalDonateDetailsListByDonatorId(this.donator.id,this.donator.token).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalDonate = int.tryParse(res);
      });
    });
    int min;
    if(totalDonate>=10){min=10;
    }else{min=totalDonate;}
    DonateDetailsService.getDonateDetailsListByDonatorIdFromAToB(this.donator.id,0,min,this.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        donate_details_list = list.map((model) => DonateDetails.fromJson(model)).toList();
      });
    });
  }

  _getNotification() async{
    await DonatorNotificationService.getTotalDonatorNotificationByDonatorId(this.donator.id,this.donator.token).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalNotification = int.tryParse(res);
      });
    });
    int min;
    if(totalNotification>=10){min=10;
    }else{min=totalNotification;}
    DonatorNotificationService.getDonatorNotificationListByDonatorIdFromAToB(this.donator.id,0,min,this.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        donator_notification_list = list.map((model) => DonatorNotification.fromJson(model)).toList();
      });
    });
  }

  _getProject() async {
    await ProjectService.getTotalProjects().then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalProject = int.tryParse(res);
      });
    });
    int min;
    if(totalProject>=10){min=10;
    }else{min=totalProject;}

    await ProjectService.getProjectsFromAToB(0,min).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        projects = list.map((model) => Project.fromJson(model)).toList();
      });
    });
  }

  _getProjectTypes(){
    ProjectService.getProjectTypes().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        project_types = list.map((model) => ProjectType.fromJson(model)).toList();
        project_types.insert(0, ProjectType(0, 'Tất cả dự án','',''));
      });
    });
  }

  _getPosts() async{
    await PostService.getTotalPost().then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalPost = int.tryParse(res);
      });
    });
    int min;
    if(totalPost>=4){min=4;
    }else{min=totalPost;}
    PostService.getPostsFromAToB(0,min).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        posts = list.map((model) => Post.fromJson(model)).toList();
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
        donator.id = prefs.getInt('donator_id');
        donator.full_name = prefs.getString('donator_full_name');
        donator.address = prefs.getString('donator_address');
        donator.phone_number = prefs.getString('donator_phone');
        donator.facebook_id = prefs.getString('donator_facebook_id');
        donator.avatar_url = prefs.getString('donator_avatar_url');
        donator.favorite_project=prefs.getString('donator_favorite_project');
        donator.favorite_notification=prefs.getString('donator_favorite_notification');
        donator.token=prefs.getString('token');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.islogin==false) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKeyUnLogged,
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
              icon: Icon(Icons.login),
              label: 'Đăng nhập',
            ),
          ],
          currentIndex: _page,
          selectedItemColor: kPrimaryHighLightColor,
          onTap:  (index) {
            _getProject();
            _getProjectTypes();
            if(index==2){
              Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
            }
            setState(() {
              _page = index;
            });
          },
        ),

        body: _page == 0 ? HomeScreen(projects: this.projects,project_types :this.project_types,isLogin: this.islogin,total: this.totalProject, )
            : PostScreen(posts: this.posts,total: this.totalPost,)

    );
    } else {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKeyLogged,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'Bản tin',
            ),
            BottomNavigationBarItem(
              label: 'Thông báo',
              icon: Stack(
                  children: <Widget>[
                    Icon(Icons.notifications),
                    if(this.isNewNotification==true)
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: new Icon(Icons.brightness_1, size: 8.0,
                            color: Colors.redAccent),
                      )
                  ]
              ),
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
          onTap: (index)  {
            setState(() {
              if(index == 0){
                _getProject();
                _getProjectTypes();
                _checkAndSubscribeFavoriteNotificationOfDonator();
                _checkNewNotificationsByDonatorId();
              }
              else if(index == 2){
                _getPosts();
                _getNotification();
                _getPushNotification();
                _checkAndSubscribeFavoriteNotificationOfDonator();
                setState(() {
                  isNewNotification=false;
                  DonatorNotificationService.putReadDonatorNotificationsByDonatorId(this.donator.id, this.donator.token);
                });
              }
              else if(index == 3){
                _getDonateHistory();
              }
              _page = index;
            });
          },
        ),
        body: (_page == 0 ? HomeScreen(projects: this.projects, project_types: this.project_types,donator: this.donator,isLogin: this.islogin,total: this.totalProject,)
            : _page == 1 ? PostScreen(posts: this.posts,donator: this.donator,total: this.totalPost,)
            : _page == 2 ? NotificationsScreen(donator_notification_list: this.donator_notification_list,donator: this.donator,total:this.totalNotification)
            : _page == 3 ? HistoryScreen(donate_details_list: this.donate_details_list,donator: this.donator,total: totalDonate,)
            : PersonalScreen(donator: this.donator,push_notification_list: this.push_notification_list))
    );
    }
  }

}



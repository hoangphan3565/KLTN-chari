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

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  StreamSubscription iosSubscription;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Timer _getNewDataAfter;
  int _page = 0;
  GlobalKey _bottomNavigationKeyUnLogged = GlobalKey();
  GlobalKey _bottomNavigationKeyLogged = GlobalKey();

  bool islogin = false;
  bool isNewNotification = false;

  var projects = new List<Project>();
  int totalProject=0;
  var project_types = new List<ProjectType>();
  var posts = new List<Post>();
  int totalPost=0;
  var donate_details_list = new List<DonateDetails>();
  int totalDonate=0;
  var push_notification_list = new List<PushNotification>();
  var donator_notification_list = new List<DonatorNotification>();
  int totalNotification=0;
  var donator = new Donator(null,null,null,null,null,null,null,null,null);


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

  _initFilterElement() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setBool('favorite',false);
    p.setStringList('listCityIdSelected',['*']);
    p.setStringList('listProjectTypeIdSelected',['*']);
    p.setStringList('listStatusSelected',['*']);

    p.setString('donatorFavorite','*');
    p.setString('ctids','*');
    p.setString('ptids','*');
    p.setString('status','*');

  }

  @override
  initState() {
    _checkLogin();
    _countTotalProject();
    _getProjectTypes();
    _countTotalPosts();

    _initFilterElement();

    if(this.islogin==true){
      _checkNewNotificationsByDonatorId();
      _countTotalDonateHistory();
      _getPushNotification();
      _checkAndSubscribeNotification();
    }

    getDataAfterBuildWidget();

    //Gọi API get dữ liệu để Cập nhật những thay đổi của các bài viết sau một khoảng thời gian
    _getNewDataAfter = Timer.periodic(Duration(seconds: 60), (Timer t) {
      _countTotalProject();
      _getProjectTypes();
      _countTotalPosts();
      if(this.islogin==true){
        _checkNewNotificationsByDonatorId();
        _countTotalDonateHistory();
        _getPushNotification();
        _checkAndSubscribeNotification();
      }
      _checkLogin();
    });
    super.initState();
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

  _checkAndSubscribeNotification() async {
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
    _fcm.subscribeToTopic('NEW');
  }

  _getPushNotification() async{
    DonatorNotificationService.getPushNotification(this.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        push_notification_list = list.map((model) => PushNotification.fromJson(model)).toList();
      });
    });
  }


  _countTotalDonateHistory() async{
    await DonateDetailsService.getTotalDonateDetailsListByDonatorId('*',this.donator.id,this.donator.token).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalDonate = int.tryParse(res);
      });
    });
  }

  _countTotalNotification() async{
    await DonatorNotificationService.getTotalDonatorNotificationByDonatorId('*',this.donator.id,this.donator.token).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalNotification = int.tryParse(res);
      });
    });
  }

  _countTotalProject() async {
    await ProjectService.getTotalProjects().then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalProject = int.tryParse(res);
      });
    });
  }

  _getProjectTypes(){
    ProjectService.getProjectTypes().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        project_types = list.map((model) => ProjectType.fromJson(model)).toList();
      });
    });
  }

  _countTotalPosts() async{
    await PostService.getTotalFoundPost('*').then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        totalPost = int.tryParse(res);
      });
    });
  }

  _checkLogin() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    DateTime expirationDate = JwtDecoder.getExpirationDate(token);

    setState(() {
      if(expirationDate!=null){
        if(token==null || expirationDate.isBefore(DateTime.now())) {
          islogin=false;
          prefs.clear();
        }
        else{
          islogin=true;
          donator.id = prefs.getInt('donator_id');
          donator.full_name = prefs.getString('donator_full_name');
          donator.address = prefs.getString('donator_address');
          donator.phone_number = prefs.getString('donator_phone');
          donator.username = prefs.getString('donator_username');
          donator.avatar_url = prefs.getString('donator_avatar_url');
          donator.favorite_project=prefs.getString('donator_favorite_project');
          donator.favorite_notification=prefs.getString('donator_favorite_notification');
          donator.token=prefs.getString('token');
        }
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
              icon: Icon(Icons.home_rounded,color: kPrimaryHighLightColor,),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined,color: kPrimaryHighLightColor,),
              label: 'Bản tin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login_rounded,color: kPrimaryHighLightColor,),
              label: 'Đăng nhập',
            ),
          ],
          currentIndex: _page,
          selectedItemColor: kPrimaryHighLightColor,
          onTap:  (index) {
            _countTotalProject();
            _getProjectTypes();
            if(index==2){
              Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
            }
            if(index!=2){
              setState(() {
                _page = index;
              });
            }
          },
        ),

        body: _page == 0 ? HomeScreen(project_types :this.project_types,isLogin: this.islogin,total: this.totalProject,)
            : PostScreen(donator: null,total: this.totalPost,)

    );
    } else {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKeyLogged,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded,color: kPrimaryHighLightColor,),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined,color: kPrimaryHighLightColor,),
              label: 'Bản tin',
            ),
            BottomNavigationBarItem(
              label: 'Thông báo',
              icon: Stack(
                  children: <Widget>[
                    Icon(Icons.notifications_rounded,color: kPrimaryHighLightColor,),
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
              icon: Icon(Icons.history_rounded,color: kPrimaryHighLightColor,),
              label: 'Lịch sử',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,color: kPrimaryHighLightColor,),
              label: 'Cá nhân',
            ),
          ],
          currentIndex: _page,
          selectedItemColor: kPrimaryHighLightColor,
          onTap: (index)  {
            setState(() {
              if(index == 0){
                _countTotalProject();
                _getProjectTypes();
                _checkAndSubscribeNotification();
                _checkNewNotificationsByDonatorId();
              }
              else if(index == 2){
                _countTotalPosts();
                _countTotalNotification();
                _getPushNotification();
                _checkAndSubscribeNotification();
                setState(() {
                  isNewNotification=false;
                  DonatorNotificationService.putReadDonatorNotificationsByDonatorId(this.donator.id, this.donator.token);
                });
              }
              else if(index == 3){
                _countTotalDonateHistory();
              }
              _page = index;
            });
          },
        ),
        body: (_page == 0 ? HomeScreen(project_types: this.project_types,donator: this.donator,isLogin: this.islogin,total: this.totalProject,)
            : _page == 1 ? PostScreen(donator: this.donator,total: this.totalPost,)
            : _page == 2 ? NotificationsScreen(donator: this.donator,total:this.totalNotification)
            : _page == 3 ? HistoryScreen(donator: this.donator,total: totalDonate,)
            : PersonalScreen(donator: this.donator,push_notification_list: this.push_notification_list))
    );
    }
  }

}



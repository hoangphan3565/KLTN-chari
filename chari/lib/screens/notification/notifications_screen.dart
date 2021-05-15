import 'dart:convert';

import 'package:chari/models/donator_notification.dart';
import 'package:chari/models/models.dart';
import 'package:chari/models/project_model.dart';
import 'package:chari/screens/home/projectdetails_screen.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  final List<DonatorNofitication> donator_notification_list;
  final List<Project> projects;

  NotificationsScreen({Key key, @required this.donator_notification_list,this.projects}) : super(key: key);
  @override
  _NotificationsScreenState createState()=> _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>{

  var push_notification_list = new List<PushNofitication>();
  var favorite_notification_list = new List<bool>();

  _getPushNotification() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    API.getPushNotification().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        push_notification_list = list.map((model) => PushNofitication.fromJson(model)).toList();
      });
    });
  }
  _getFavoriteNotification() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int donator_id = _prefs.getInt('donator_id');
    String token = _prefs.getString('token');
    API.getFavoriteNotificationList(donator_id, token).then((response) {
      setState(() {
        List<bool> list = (json.decode(response.body) as List<dynamic>).cast<bool>();
        favorite_notification_list = list;
      });
    });
  }

  @override
  void initState() {
    _getPushNotification();
    _getFavoriteNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(0))),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: kPrimaryLightColor,
                centerTitle: true,
                floating: true,
                title: Text(
                  'Thông báo',
                  style: const TextStyle(
                    fontSize: 27.0,
                    color: kPrimaryHighLightColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      FontAwesomeIcons.search,
                    ),
                    onPressed: () {
                      // do something
                    },
                  ),
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => SettingNotificationScreen(push_notification_list:push_notification_list,favorite_notification_list:favorite_notification_list)));
                    },
                  ),
                ],
              ),
              widget.donator_notification_list.length == 0 ?
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 300.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Chưa có thông báo nào!",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: kPrimaryHighLightColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              )
                  :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index){
                    return buildNotificationInfo(widget.donator_notification_list[index]);},
                  childCount:  widget.donator_notification_list.length,
                ),
              )
            ],
          )
        ),
    );
  }

  _showAskForMoveMoneyDialog(BuildContext context,int project_id,int donator_id,String token){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Xử lý chuyển dời tiền đã ủng hộ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 1.5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 10),
                    Text("Chuyển tất cả số tiền mà bạn đã ủng hộ đến dự án khác mà bạn muốn",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    RoundedButton(
                        text: "Chuyển đến dự án khác",
                        press: (){
                          Navigator.pop(context);
                        }
                    ),
                    Text("Hoặc",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    RoundedButton(
                        text: "Chuyển đến quỹ chung",
                        textColor: kPrimaryHighLightColor,
                        color: kPrimaryLightColor,
                        press: () async {
                          Navigator.pop(context);
                          var res = await API.putMoveMoneyToGeneralFund(project_id, donator_id, token);
                          var jsRes = json.decode(utf8.decode(res.bodyBytes));
                          Fluttertoast.showToast(
                              msg: jsRes['message'],
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kPrimaryColor,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showInformDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Trường hợp này đã được xử ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 1.5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 10),
                    RoundedButton(
                        text: "Đóng",
                        press: (){
                          Navigator.pop(context);
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  GestureDetector buildNotificationInfo(DonatorNofitication nofitication){
    return GestureDetector(
        onTap: () async {
          if(nofitication.topic!='closed'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: widget.projects.where((p) => p.prj_id==nofitication.project_id).elementAt(0),)),
            );
          }
          if(nofitication.topic=='closed'){
            if(nofitication.is_handled==true){
              _showInformDialog(context);
            }
            if(nofitication.is_handled!=true){
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _showAskForMoveMoneyDialog(context,nofitication.project_id,_prefs.getInt('donator_id'),_prefs.getString('token'));
            }
          }
        },
        child:  Container(
          margin: EdgeInsets.fromLTRB(8,5,8,5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: nofitication.topic!='closed' ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      nofitication.title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      nofitication.message,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat('kk:mm dd-MM-yy').format(DateTime.parse(nofitication.create_time)),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              widget.projects.where((p) => p.prj_id==nofitication.project_id).length != 0 ?
              Container(
                height: 90,
                width: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.projects.where((p) => p.prj_id==nofitication.project_id).elementAt(0).image_url)
                    )),
              )
                  :
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/loading.gif")
                      ))
              )

            ],
          )
              :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      nofitication.title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      nofitication.message,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat('kk:mm dd-MM-yy').format(DateTime.parse(nofitication.create_time)),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          )
        )
    );
  }
}

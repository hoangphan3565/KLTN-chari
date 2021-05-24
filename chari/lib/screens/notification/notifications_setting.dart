
import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotificationScreen extends StatefulWidget {
  List<PushNotification> push_notification_list;
  List<bool> favorite_notification_list;
  SettingNotificationScreen({Key key, @required this.push_notification_list,this.favorite_notification_list}) : super(key: key);
  @override
  _SettingNotificationScreenState createState()=> _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen>{

  final FirebaseMessaging _fcm = FirebaseMessaging();

  changeStateNotificationList(String topic,int nof_id,bool value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int donator_id = _prefs.getInt('donator_id');
    String token = _prefs.getString('token');
    API.changeStateFavoriteNotificationList(donator_id, nof_id, value, token).then((value) =>
        _prefs.setString('donator_favorite_notification',value.toString())
    );
    if(value==true){
      _fcm.subscribeToTopic(topic);
    }else{
      _fcm.unsubscribeFromTopic(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Cài đặt thông ',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for(int i=0;i<widget.push_notification_list.length;i++)
              SwitchListTile(
                title: Text(widget.push_notification_list.elementAt(i).title),
                value: widget.favorite_notification_list.elementAt(i),
                onChanged: (bool value){
                  setState(() {
                    widget.favorite_notification_list[i]=value;
                    changeStateNotificationList(widget.push_notification_list.elementAt(i).topic,widget.push_notification_list.elementAt(i).nof_ID,value);
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}

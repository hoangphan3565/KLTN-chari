

import 'package:chari/models/models.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    DonatorService.changeStateFavoriteNotificationList(donator_id, nof_id, value, token).then((value) =>
        _prefs.setString('donator_favorite_notification',value.toString())
    );
    if(topic=='NEW'){
      if(value){
        _fcm.subscribeToTopic(topic);
      }else{
        _fcm.unsubscribeFromTopic(topic);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 0),
      child: Stack(
        children: [
          Positioned(
            right: size.width*0.35,top:-26,
            child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text("Cài đặt thông báo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryHighLightColor,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 1.5,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(horizontal: 0),
              ),
              for(int i=0;i<widget.push_notification_list.length;i++)
                SwitchListTile(
                  title: Text(widget.push_notification_list.elementAt(i).description,style: TextStyle(fontSize: 13),),
                  value: widget.favorite_notification_list.elementAt(i),
                  activeColor: kPrimaryHighLightColor,
                  onChanged: (bool value){
                    setState(() {
                      widget.favorite_notification_list[i]=value;
                      changeStateNotificationList(widget.push_notification_list.elementAt(i).topic,widget.push_notification_list.elementAt(i).nof_ID,value);
                    });
                  },
                )
            ],
          ),
        ],
      ),
    );
  }
}

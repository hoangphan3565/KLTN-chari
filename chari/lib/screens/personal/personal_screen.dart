
import 'dart:convert';

import 'package:chari/API.dart';
import 'file:///D:/HCMUTE/HK8/KLTN-chari/chari/lib/utility/constants.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PersonalScreen extends StatefulWidget {
  final Donator donator;
  PersonalScreen({Key key, @required this.donator}) : super(key: key);
  @override
  _PersonalScreenState createState()=> _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {

  String fullname;
  String address;


  initState() {
    _getDonatorDetails();
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  _getDonatorDetails() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname=_prefs.getString('donator_full_name');
      address=_prefs.getString('donator_address');
    });
  }

  _updateInformation(int id, String fullname, String address) async{
    String url = baseUrl+donators+"/update/id/"+id.toString();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final body = jsonEncode(<String, String>{
      "fullName": fullname,
      "address": address,
    });
    var jsonResponse;
    var res = await http.post(url,headers:getHeaderJWT(_prefs.getString('token')),body: body);
    jsonResponse = json.decode(utf8.decode(res.bodyBytes));
    //Hiện thông báo theo messenge được trả về từ server
    Fluttertoast.showToast(
        msg: jsonResponse['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
    //Kiem tra API Status - 200 tức là đổi thành công - theo như mô tả từ server.
    if(res.statusCode == 200){
      // lưu thông tin mới được cập nhật vào SharedPreferences
      setState(() {
        _prefs.setString('donator_full_name',jsonResponse['data']['fullName']);
        _prefs.setString('donator_address',jsonResponse['data']['address']);
        this.fullname=_prefs.getString('donator_full_name');
        this.address=_prefs.getString('donator_address');
      });
      //Đóng dialog khi cập nhật thành công
      Navigator.pop(context);
    }
  }

  _showChangeInformationDialog(BuildContext context) {
    TextEditingController _fullnameField = TextEditingController(text: fullname);
    TextEditingController _addressField = TextEditingController(text: address);
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
                    Text("Cập nhật thông tin cá nhân",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 1.5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 5),
                    RoundedInputField(
                      icon: Icons.person,
                      hintText: 'Họ và tên',
                      keyboardType: TextInputType.name,
                      controller: _fullnameField,
                      onTapClearIcon: ()=>{_fullnameField.clear()},
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      icon: FontAwesomeIcons.addressCard,
                      hintText: 'Địa chỉ',
                      keyboardType: TextInputType.streetAddress,
                      controller: _addressField,
                      onTapClearIcon: ()=>{_addressField.clear()},
                      onChanged: (value) {},
                    ),

                    RoundedButton(
                      text: "Xác nhận",
                      press: ()async{
                        SharedPreferences _prefs = await SharedPreferences.getInstance();
                        _updateInformation(_prefs.getInt('donator_id'),_fullnameField.text,_addressField.text);
                      },
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Trang cá nhân',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.7,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(),
          Expanded(
            child: SingleChildScrollView(
              child:  Column(
                  children: [
                    SizedBox(height: kSpacingUnit.toDouble() * 2),
                    Container(
                      height: kSpacingUnit.toDouble() * 18,
                      width: kSpacingUnit.toDouble() * 18,
                      margin: EdgeInsets.only(top: kSpacingUnit.toDouble() * 3),
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: kSpacingUnit.toDouble() * 15,
                            backgroundImage: NetworkImage(widget.donator.avatar_url)
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kSpacingUnit.toDouble() * 2),
                    Text(
                      this.fullname == null ? '' : this.fullname,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: kSpacingUnit.toDouble() * 0.5),
                    Text(
                      widget.donator.phone_number,
                      style: TextStyle(
                        fontSize: kSpacingUnit.toDouble() * 1.7,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: kSpacingUnit.toDouble() * 5),
                    RoundedButton(
                      text: 'Đóng góp ý kiến',
                      fontsize: 17,
                      press: ()=>{
                        FeedBackService.showSendFeedbackDialog(context)
                      },
                    ),
                    RoundedButton(
                      text: 'Cập nhật thông tin',
                      fontsize: 17,
                      press: ()=>{
                        _showChangeInformationDialog(context)
                      },
                    ),
                    RoundedButton(
                      text: 'Đổi mật khẩu',
                      fontsize: 17,
                      press: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => ChangePasswordScreen(username: prefs.getString('username'),password: prefs.getString('password'))));
                      },
                    ),
                    RoundedButton(
                      text: 'Đăng xuất',
                      fontsize: 17,
                      press: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        API.saveFCMToken(prefs.getString('username'), null);
                        await prefs.clear();
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => AppBarScreen()));
                      },
                    ),
                  ]
              )
            ),
          ),
        ],
      ),
    );
  }
}
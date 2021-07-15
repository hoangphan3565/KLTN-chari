import 'dart:convert';

import 'package:chari/models/models.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class UpdateInfoScreen extends StatefulWidget {
  Donator donator;
  UpdateInfoScreen({Key key, @required this.donator}) : super(key: key);
  @override
  _UpdateInfoScreenState createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  var focusNode = FocusNode();
  bool haveFullName = false;
  bool haveAddress = false;
  TextEditingController _fullnameField;
  TextEditingController _addressField;

  @override
  initState() {
    focusNode.requestFocus();
    widget.donator.full_name!=''?setState(() {haveFullName=true;}):setState(() {haveFullName=false;});
    widget.donator.address!=''?setState(() {haveAddress=true;}):setState(() {haveAddress=false;});
    _fullnameField = TextEditingController(text: widget.donator.full_name);
    _addressField = TextEditingController(text: widget.donator.address);
    super.initState();
  }

  _updateInformation(int id, String fullname, String address) async{
    String url = baseUrl+donators+"/update/id/"+id.toString();
    SharedPreferences p = await SharedPreferences.getInstance();
    final body = jsonEncode(<String, String>{
      "fullName": fullname,
      "address": address,
    });
    var jsonResponse;
    var res = await http.post(url,headers:getHeaderJWT(p.getString('token')),body: body);
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
    //Kiem tra UserService Status - 200 tức là đổi thành công - theo như mô tả từ server.
    if(res.statusCode == 200){
      // lưu thông tin mới được cập nhật vào SharedPreferences
      setState(() {
        p.setString('donator_full_name',jsonResponse['data']['fullName']);
        p.setString('donator_address',jsonResponse['data']['address']);
      });
      //Đóng dialog khi cập nhật thành công
      Navigator.pop(context,'updated');
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 24),
      child: Stack(
        children: [
          Positioned(
            right: size.width*0.35,top:-28,
            child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                Text("Cập nhật thông tin cá nhân",
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
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      RoundedInputField(
                        icon: Icons.person,
                        focusNode: focusNode,
                        hintText: 'Họ và tên',
                        keyboardType: TextInputType.name,
                        controller: _fullnameField,
                        showClearIcon: haveFullName,
                        onTapClearIcon: ()=>{_fullnameField.clear(),setState(() {haveFullName=false;})},
                        onChanged: (value) {
                          value!=''?setState(() {haveFullName=true;}):setState(() {haveFullName=false;});
                        },
                      ),
                      RoundedInputField(
                        icon: FontAwesomeIcons.addressCard,
                        hintText: 'Địa chỉ',
                        keyboardType: TextInputType.streetAddress,
                        controller: _addressField,
                        showClearIcon: haveAddress,
                        onTapClearIcon: ()=>{_addressField.clear(),setState(() {haveAddress=false;})},
                        onChanged: (value) {
                          value!=''?setState(() {haveAddress=true;}):setState(() {haveAddress=false;});
                        },
                      ),

                      RoundedButton(
                        text: "Xác nhận",
                        press: (){
                          _updateInformation(widget.donator.id,_fullnameField.text,_addressField.text);
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),

    );
  }
}
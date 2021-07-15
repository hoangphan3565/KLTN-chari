import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChangePasswordScreen extends StatefulWidget {
  final String username;
  final String password;
  ChangePasswordScreen({@required this.username,this.password});
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _curPasswordField = TextEditingController();
  TextEditingController _newPasswordField = TextEditingController();
  TextEditingController _reWritePasswordField = TextEditingController();
  bool notSeePassword = true;
  bool notSeePassword1 = true;
  bool notSeePassword2 = true;
  bool havePass = false;
  bool havePass1 = false;
  bool havePass2 = false;
  var focusNode = FocusNode();

  @override
  initState() {
    super.initState();
    focusNode.requestFocus();
  }
  _changePassword(String username,String password, String cur_password,String new_password1,String new_password2) async{
    String message='';
    int errorCode=1;
    if(cur_password.length != 0 && new_password1.length !=0 && new_password2.length!=0) {
      if(cur_password==password){
        if(new_password1==new_password2){
          if(new_password1!=password){
            if(CheckString.isMyCustomPassword(new_password1)){
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              var res = await UserService.changeUserPassword(username, new_password1, new_password2);
              var jsonResponse = json.decode(utf8.decode(res.bodyBytes));
              message = jsonResponse['message'];
              errorCode = jsonResponse['errorCode'];
              if(errorCode == 0){
                _prefs.setString('password',new_password1);
                Navigator.pop(context);
              }}else{
              message='Mật khẩu mới phải có ít nhất 6 ký tự và gồm chữ và số!';
            }}else{
            message='Mật khẩu mới phải khác mật khẩu cũ!';
          }}else{
          message='Mật khẩu mới không trùng khớp!';
        }}else{
        message='Mật khẩu hiện tại không chính xác!';
      }}else{
      message='Không được trống thông tin nào';
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorCode==0? kPrimaryColor:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
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
                Text("Đổi mật khẩu",
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      TextFieldContainer(
                        child: Text('Mật khẩu mới phải thỏa các điều kiện sau\n- Phải khác mật khẩu cũ\n- Phải có 8 đến 15 ký tự\n- Phải có ít nhất 1 ký tự số và 1 ký tự chữ\nVí dụ: aqk153 hoặc 153aqk',
                            style: TextStyle(
                              color: kPrimaryHighLightColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      RoundedPasswordField(
                        hintText: "Mật khẩu hiện tại",
                        focusNode: focusNode,
                        icon: FontAwesomeIcons.unlock,
                        obscureText: notSeePassword,
                        controller: _curPasswordField,
                        showClearIcon: havePass,
                        onTapClearIcon: ()=>{_curPasswordField.clear(),setState(() {havePass=false;})},
                        switchObscureTextMode: ()=>{
                          notSeePassword==true?setState((){notSeePassword=false;}):setState((){notSeePassword=true;})
                        },
                        onChanged: (value) {
                          value!=''?setState(() {havePass=true;}):setState(() {havePass=false;});
                        },
                      ),
                      RoundedPasswordField(
                        hintText: "Mật khẩu mới",
                        icon: FontAwesomeIcons.lockOpen,
                        obscureText: notSeePassword1,
                        controller: _newPasswordField,
                        showClearIcon: havePass1,
                        onTapClearIcon: ()=>{_newPasswordField.clear(),setState(() {havePass1=false;})},
                        switchObscureTextMode: ()=>{
                          notSeePassword1==true?setState((){notSeePassword1=false;}):setState((){notSeePassword1=true;})
                        },
                        onChanged: (value) {
                          value!=''?setState(() {havePass1=true;}):setState(() {havePass1=false;});
                        },
                      ),
                      RoundedPasswordField(
                        hintText: "Nhập lại mật khẩu mới",
                        icon: FontAwesomeIcons.lock,
                        obscureText: notSeePassword2,
                        controller: _reWritePasswordField,
                        onTapClearIcon: ()=>{_reWritePasswordField.clear(), setState(() {havePass2=false;}),},
                        showClearIcon: havePass2,
                        switchObscureTextMode: ()=>{
                          notSeePassword2==true?setState((){notSeePassword2=false;}):setState((){notSeePassword2=true;})
                        },
                        onChanged: (value) {
                          value!=''?setState(() {havePass2=true;}):setState(() {havePass2=false;});
                        }
                      ),
                      RoundedButton(
                        text: "Xác nhận",
                        press: ()=>{
                          _changePassword(widget.username,widget.password,_curPasswordField.text,_newPasswordField.text,_reWritePasswordField.text)
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
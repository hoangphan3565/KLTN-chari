import 'dart:convert';

import 'package:chari/API.dart';
import 'package:chari/constants.dart';
import 'package:chari/screens/appbar_screen.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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

  _changePassword(String username,String password, String cur_password,String new_password1,String new_password2) async{
    String message='';
    int errorCode=1;
    if(cur_password.length != 0 && new_password1.length !=0 && new_password2.length!=0) {
      if(cur_password==password){
        if(new_password1==new_password2){
          if(new_password1!=password){
            if(CheckString.isMyCustomPassword(new_password1)){
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              var res = await API.changeUserPassword(username, new_password1, new_password2);
              var jsonResponse = json.decode(utf8.decode(res.bodyBytes));
              message = jsonResponse['message'];
              errorCode = jsonResponse['errorCode'];
              if(errorCode == 0){
                _prefs.setString('password',jsonResponse['data']['password']);
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
        backgroundColor: errorCode==0? Colors.green:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Đổi mật khẩu',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => AppBarScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(0))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Image.asset(
                    //   "assets/icons/change-password.jpg",
                    //   height: size.height * 0.2,
                    // ),
                    TextFieldContainer(
                      child: Text('Mật khẩu mới phải thỏa các điều kiện sau\n- Phải khác mật khẩu cũ\n- Phải có 8 đến 15 ký tự\n- Phải có ít nhất 1 ký tự số và 1 ký tự chữ\nVí dụ: aqk153 hoặc 153aqk',
                        style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    RoundedPasswordField(
                      hintText: "Mật khẩu hiện tại",
                      icon: LineAwesomeIcons.alternate_unlock,
                      obscureText: notSeePassword,
                      controller: _curPasswordField,
                      onTapClearIcon: ()=>{_curPasswordField.clear()},
                      switchObscureTextMode: ()=>{
                        if(notSeePassword==true){
                          setState((){notSeePassword=false;})
                        }else{
                          setState((){notSeePassword=true;})
                        }
                      },
                      onChanged: (value) {},
                    ),
                    RoundedPasswordField(
                      hintText: "Mật khẩu mới",
                      icon: LineAwesomeIcons.lock_open,
                      obscureText: notSeePassword1,
                      controller: _newPasswordField,
                      onTapClearIcon: ()=>{_newPasswordField.clear()},
                      switchObscureTextMode: ()=>{
                        if(notSeePassword1==true){
                          setState((){notSeePassword1=false;})
                        }else{
                          setState((){notSeePassword1=true;})
                        }
                      },
                      onChanged: (value) {},
                    ),
                    RoundedPasswordField(
                      hintText: "Nhập lại mật khẩu mới",
                      icon: LineAwesomeIcons.lock,
                      obscureText: notSeePassword2,
                      controller: _reWritePasswordField,
                      onTapClearIcon: ()=>{_reWritePasswordField.clear()},
                      switchObscureTextMode: ()=>{
                        if(notSeePassword2==true){
                          setState((){notSeePassword2=false;})
                        }else{
                          setState((){notSeePassword2=true;})
                        }
                      },
                      onChanged: (value) {},
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
            ),
          )
        ],
      ),
    );
  }
}
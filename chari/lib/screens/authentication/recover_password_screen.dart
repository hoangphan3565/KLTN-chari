import 'dart:convert';

import 'package:chari/API.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RecoverPasswordScreen extends StatefulWidget {
  final String phone;
  RecoverPasswordScreen({@required this.phone});
  @override
  _RecoverPasswordScreenState createState()=> _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen>{
  TextEditingController _password1Controller = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  bool notSeePassword1=true;
  bool notSeePassword2=true;

  //Hàm xử lý đăng ký bằng API
  _recoverPassword(String username, String new_password1,String new_password2) async{
    String message='';
    int errorCode=1;
    if(new_password1.length !=0 && new_password2.length!=0) {
      if(new_password1==new_password2) {
        if(CheckString.isMyCustomPassword(new_password1)){
          var res = await API.changeUserPassword(username, new_password1, new_password2);
          var jsonResponse = json.decode(utf8.decode(res.bodyBytes));
          message = jsonResponse['message'];
          errorCode = jsonResponse['errorCode'];
          if(errorCode == 0){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
          }}else{
          message='Mật khẩu mới phải có ít nhất 6 ký tự và gồm chữ và số!';
        }}else{
        message='Mật khẩu mới không trùng khớp!';
      }}else{
      message ='Không được trống thông tin nào';
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorCode == 0? kPrimaryColor: Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Lấy lại mật khẩu",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Image.asset(
                "assets/icons/change-password.jpg",
                height: size.height * 0.25,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                widget.phone,
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedPasswordField(
                hintText: "Nhập mật khẩu",
                icon: FontAwesomeIcons.lockOpen,
                obscureText: notSeePassword1,
                controller: _password1Controller,
                onTapClearIcon: ()=>{_password1Controller.clear()},
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
                hintText: "Nhập lại mật khẩu",
                icon: FontAwesomeIcons.lock,
                obscureText: notSeePassword2,
                controller: _password2Controller,
                onTapClearIcon: ()=>{_password2Controller.clear()},
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
                press:(){
                  _recoverPassword(widget.phone,_password1Controller.text,_password2Controller.text);
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

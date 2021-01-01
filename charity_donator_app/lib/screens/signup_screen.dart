import 'dart:convert';

import 'package:charity_donator_app/API.dart';
import 'package:charity_donator_app/constants.dart';
import 'package:charity_donator_app/screens/screens.dart';
import 'package:charity_donator_app/utility/utility.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState()=> _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _password1Controller = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  bool notSeePassword1=true;
  bool notSeePassword2=true;

  //Hàm xử lý đăng ký bằng API
  _singUp(String username, String password1,String password2) async{
    String message='';
    int errorCode=1;
    if(username.length != 0 && password1.length !=0 && password2.length!=0) {
      if(username.length==10 && CheckString.onlyNumber(username)) {
        if(password1==password2) {
          if(CheckString.isMyCustomPassword(password1)) {
            String url = baseUrl+register;
            final body = jsonEncode(<String, String>{
              "username":username,
              "password1":password1,
              "password2":password2,
              "usertype":"Donator"
            });
            var res = await http.post(url,headers:header,body: body);
            var jsonResponse = json.decode(utf8.decode(res.bodyBytes));
            message = jsonResponse['message'];
            errorCode = jsonResponse['errorCode'];
            if(errorCode==0) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()), (Route<dynamic> route) => false);
            }}else{
            message ='Mật khẩu mới phải có ít nhất 6 ký tự và gồm chữ và số!';
          }}else{
          message ='Mật khẩu mới không trùng khớp!';
        }}else{
        message ='Số điện thoại không chính xác!';
      }}else{
      message ='Không được trống thông tin nào';
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorCode == 0? Colors.green: Colors.orangeAccent,
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
                "Đăng ký",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                "assets/icons/signup.png",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                hintText: "Nhập Số điện thoại",
                icon: LineAwesomeIcons.phone,
                keyboardType: TextInputType.number,
                controller: _usernameController,
                onTopClearIcon: ()=>{_usernameController.clear()},
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                hintText: "Nhập mật khẩu",
                icon: LineAwesomeIcons.lock_open,
                obscureText: notSeePassword1,
                controller: _password1Controller,
                onTapSuffixIcon: ()=>{
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
                icon: LineAwesomeIcons.lock,
                obscureText: notSeePassword2,
                controller: _password2Controller,
                onTapSuffixIcon: ()=>{
                  if(notSeePassword2==true){
                    setState((){notSeePassword2=false;})
                  }else{
                    setState((){notSeePassword2=true;})
                  }
                },
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "Đăng ký",
                press:(){
                  _singUp(_usernameController.text,_password1Controller.text,_password2Controller.text);
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

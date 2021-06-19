import 'dart:async';
import 'dart:convert';

import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState()=> _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _password1Controller = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  bool notSeePassword1=true;
  bool notSeePassword2=true;
  var focusNode = FocusNode();

  @override
  initState() {
    super.initState();
    focusNode.requestFocus();
  }
  //Hàm xử lý đăng ký bằng UserService
  _singUp(String username, String password1,String password2) async{
    String message='';
    int errorCode=1;
    if(username.length != 0 && password1.length !=0 && password2.length!=0) {
      if(username.length==10 && CheckString.onlyNumber(username)) {
        if(password1==password2) {
          if(CheckString.isMyCustomPassword(password1)) {
            var res = await UserService.signup(username, password1, password2);
            var jsonResponse = json.decode(utf8.decode(res.bodyBytes));
            message = jsonResponse['message'];
            errorCode = jsonResponse['errorCode'];
            if(errorCode==0) {
              sendCodeToUser("+84"+username.substring(1),context);
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
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorCode == 0? kPrimaryColor: Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  //Hàm này dùng firebase như một backend trung gian mục đích để xác thực xem sđt user nhập có phải là sdt thật hay không
  //nếu sdt là thật thì lần đăng nhập sau ko cần gửi mã xác nhận nữa
  Future sendCodeToUser(String phone, BuildContext context) async {
    String NavitePhone="0"+phone.substring(3);
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 120),
      //Trương hợp xác thực trên cùng 1 thiết bị - ko cần nhập code vẫn xác thực thành công.
      verificationCompleted: (AuthCredential authCredential) {
        _firebaseAuth.signInWithCredential(authCredential).then((AuthResult result) async {
          Navigator.of(context).pop(); // to pop the dialog box
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
          await UserService.activateUser(NavitePhone);
          await UserService.saveUser(NavitePhone);
          Fluttertoast.showToast(
                msg: "Đăng ký thành công!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kPrimaryColor,
                textColor: Colors.white,
                fontSize: 16.0
            );
        }).catchError((e) {
          return "error";
        });
      },
      verificationFailed: (AuthException exception) {
        Fluttertoast.showToast(
          msg: "Xác thực thất bại! SĐT không tồn tại!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: 16.0
        );
        UserService.deleteUserByUserName(NavitePhone);
        return "error";
      },
      codeSent: (String verificationId, [int forceResendingToken]) async {
        final result = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => EnterCodeScreen(phone: phone,verificationId: verificationId,firebaseAuth: _firebaseAuth,)));
        if(await result=='successful'){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
          await UserService.activateUser(NavitePhone);
          await UserService.saveUser(NavitePhone);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Text(
          "Đăng ký",
          style: TextStyle(
            color: kPrimaryHighLightColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: -1.2,
          ),
        ),
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/icons/logo.png",
                height: size.height * 0.13,
              ),
              SizedBox(height: size.height * 0.06),
              RoundedInputField(
                hintText: "Nhập Số điện thoại",
                focusNode: focusNode,
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.number,
                controller: _usernameController,
                onTapClearIcon: ()=>{_usernameController.clear()},
                onChanged: (value) {},
              ),
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
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

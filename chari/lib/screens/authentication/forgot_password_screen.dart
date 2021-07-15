import 'dart:convert';

import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/services/user_service.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState()=> _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  var focusNode = FocusNode();
  bool havePhone=false;
  @override
  initState() {
    super.initState();
    focusNode.requestFocus();
  }

  //Hàm xác nhận sdt
  Future _sendCodeToUser(String phone, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String NavitePhone = "0"+phone.substring(3);
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 120),
      verificationCompleted: (AuthCredential authCredential) {
        _firebaseAuth.signInWithCredential(authCredential).then((AuthResult result){
          Navigator.of(context).pop(); // to pop the dialog box
          Fluttertoast.showToast(
              msg: 'Xác thực thành công!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: kPrimaryColor,
              textColor: Colors.white,
              fontSize: 16.0
          );
          UserService.activateUser(NavitePhone);
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => RecoverPasswordScreen(phone: NavitePhone)));
          return "successful";
        }).catchError((e) {
          return "error";
        });
      },
      verificationFailed: (AuthException e) {
        String msg;
        if(e.code == 'invalid-phone-number') {
          msg="Số điện thoại không tồn tại!";
          UserService.deleteUserByUserName(NavitePhone);
        }else{
          msg="Đã quá số lần xác thực quy định!\nHãy quay lại sau 24 giờ!";
        }
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orangeAccent,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return "error";
      },
      codeSent: (String verificationId, [int forceResendingToken]) async {
        final result = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => EnterCodeScreen(phone: phone,verificationId: verificationId,firebaseAuth: _firebaseAuth,)));
        if(await result=='successful'){
          UserService.activateUser(NavitePhone);
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => RecoverPasswordScreen(phone: NavitePhone)));
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      });
  }

  _findUserAndSendCodeIfAvailable(String username, BuildContext context) async {
    var res = await UserService.findUserByUserName(username);
    var jsRes = json.decode(utf8.decode(res.bodyBytes));
    String message='';
    int errorCode=1;
    message = jsRes['message'];
    errorCode = jsRes['errorCode'];
    if(errorCode==0) {
      _sendCodeToUser("+84"+username.substring(1),context);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Lấy lại mật khẩu",
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
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Nhập Số điện thoại",
                focusNode: focusNode,
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.number,
                controller: _usernameController,
                showClearIcon: havePhone,
                onTapClearIcon: ()=>{_usernameController.clear(),setState(() {havePhone=false;})},
                onChanged: (value) {
                  value!=''?setState(() {havePhone=true;}):setState(() {havePhone=false;});
                },
                onSubmitted: (value){
                  _findUserAndSendCodeIfAvailable(value,context);
                },
              ),

              RoundedButton(
                text: "Tiếp tục",
                press: () {
                  _findUserAndSendCodeIfAvailable(_usernameController.text.toString().trim(),context);
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

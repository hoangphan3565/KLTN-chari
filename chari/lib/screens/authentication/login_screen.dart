import 'dart:convert';

import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
    _LoginScreenState createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool notSeePassword = true;
  bool havePhone = false;
  bool havePass = false;

  _loginFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();

    final result = await facebookLogin.logIn(['email']);
    final fb_token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name&access_token=${fb_token}');
    final fbUser = json.decode(utf8.decode(graphResponse.bodyBytes));
    final fbId=fbUser['id'];
    final fbName=fbUser['name'];
    final avatar = "http://graph.facebook.com/$fbId/picture?type=square";
    print(avatar);
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString('fb_token',fb_token);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(accessToken: fb_token);
      _firebaseAuth.signInWithCredential(credential);
    }

    var res = await UserService.loginFB(fbName,fbId,avatar);
    _saveDeviceToken(fbId);
    var jsRes = json.decode(utf8.decode(res.bodyBytes));
    if(res.statusCode == 200) {
      if(jsRes['data']['usertype']!='Donator'&&jsRes['data']['usertype']!=null){
        Fluttertoast.showToast(
            msg: 'Không thể đăng nhập',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return;
      }else{
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jsRes['token']);
        p.setString('token',jsRes['token']);
        p.setString('username',decodedToken['sub']);

        final donator = Donator.fromJson(jsRes['info']);
        p.setInt('donator_id',donator.id);
        p.setString('donator_address',donator.address);
        p.setString('donator_full_name',donator.full_name);
        p.setString('donator_phone',donator.phone_number);
        p.setString('donator_avatar_url',donator.avatar_url);
        p.setString('donator_username',donator.username);
        p.setString('donator_favorite_project',donator.favorite_project);
        p.setString('donator_favorite_notification',donator.favorite_notification);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> MainScreen()), (Route<dynamic> route) => false);
      }
    }
    Fluttertoast.showToast(
        msg: res.statusCode == 200 ? 'Đăng nhập thành công!':'Đăng nhập thất bại!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: res.statusCode == 200 ? kPrimaryColor:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  _login(String username, String password) async{
    var res = await UserService.signin(username, password);
    var jsRes = json.decode(utf8.decode(res.bodyBytes));
    //Kiem tra API Status
    if(res.statusCode == 200) {
      if(jsRes['data']['usertype']!='Donator'&&jsRes['data']['usertype']!=null){
        Fluttertoast.showToast(
            msg: 'Không thể đăng nhập',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return;
      }else{
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jsRes['token']);
        DateTime expirationDate = JwtDecoder.getExpirationDate(jsRes['token']);
        print("Token sẽ hết hạn vào: "+expirationDate.toString()); //Hết hạn vào:

        // lưu token vào SharedPreferences
        SharedPreferences p = await SharedPreferences.getInstance();
        p.setString('token',jsRes['token']);
        p.setString('username',decodedToken['sub']);
        p.setString('password',password);
        final donator = Donator.fromJson(jsRes['info']);
        p.setInt('donator_id',donator.id);
        p.setString('donator_address',donator.address);
        p.setString('donator_full_name',donator.full_name);
        p.setString('donator_phone',donator.phone_number);
        p.setString('donator_avatar_url',donator.avatar_url);
        p.setString('donator_username',donator.username);
        p.setString('donator_favorite_project',donator.favorite_project);
        p.setString('donator_favorite_notification',donator.favorite_notification);

        //Chuyển hướng đến trang chính và xóa tất cả context trước đó
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> MainScreen()), (Route<dynamic> route) => false);
      }
    }
    Fluttertoast.showToast(
        msg: res.statusCode == 200 ? 'Đăng nhập thành công!':'Sai SĐT hoặc mật khẩu!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: res.statusCode == 200 ? kPrimaryColor:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  _saveDeviceToken(String username) async{
    String fcmToken = await _fcm.getToken();
    UserService.saveFCMToken(username, fcmToken);
  }


  //Hàm kiểm tra định dạng đầu vào -> xem tài khoản đã được xác nhận hay chưa -> nếu chưa thì gửi code -> nếu xác thực thành công thì thực hiện đăng nhập
  _validateCheckActivetedSendCodeAndLoginIfVerifySuccessful(String username, String password) async{
    String error_message='';
    if(username.length != 0 && password.length !=0) {
      if(username.length==10 && CheckString.onlyNumber(username)){
        if(CheckString.isMyCustomPassword(password)){
          var res = await UserService.signin(username, password);
          var jsRes = json.decode(utf8.decode(res.bodyBytes));
          //Kiem tra API Status
          if(res.statusCode == 200) {
            if(jsRes['data']['status']!='BLOCKED'){
              //Khi đăng nhập với tài khoản chưa được xác nhận
              if(jsRes['data']['status']=='NOT_ACTIVATED') {
                Fluttertoast.showToast(
                    msg: 'Số điện thoại chưa được xác thực!',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Fluttertoast.showToast(
                    msg: 'Mã xác thực sẽ được gửi đến '+username,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: kPrimaryColor,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                //Gửi code xác nhận và kích hoạt tài khoản
                _sendCodeToUser("+84"+username.substring(1),password,context);
              }
              else{
                _saveDeviceToken(_usernameController.text);
                _login(_usernameController.text,_passwordController.text);
              }
            }else{
              error_message='Tài khoản đã bị khoá!';
            }}else{
            error_message='Sai SĐT hoặc mật khẩu!';
          }}else{
          error_message='Sai SĐT hoặc mật khẩu!';
        }}else{
        error_message='Sai SĐT hoặc mật khẩu!';
      }}else{
      error_message='Không được trống thông tin nào!';
    }
    if(error_message.length>0){
      Fluttertoast.showToast(
          msg: error_message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  //Hàm xác nhận sdt tương tự như bên đăng ký - tuy nhiên hàm này đảm bảo khi người dùng đăng nhập với một tk chưa dc đk thì firebase sẽ gửi mã để xác nhận
  Future _sendCodeToUser(String phone,String password, BuildContext context) {
    String NavitePhone = "0"+phone.substring(3);
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential authCredential) {
          _firebaseAuth.signInWithCredential(authCredential).then((AuthResult result) async {
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
            await UserService.activateUser(NavitePhone);
            await UserService.saveUser(NavitePhone);
            _login(_usernameController.text,_passwordController.text);
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
            await UserService.activateUser(NavitePhone);
            await UserService.saveUser(NavitePhone);
            _login(_usernameController.text,_passwordController.text);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Text(
          "Đăng nhập",
          style: TextStyle(
            color: kPrimaryHighLightColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: -1.2,
          ),
        ),
        actions: [
          IconButton(
              splashRadius: size.height * 0.03,
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              onPressed: (){_setBaseUrl();}
          ),
        ],
      ),
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.06),
                Image.asset(
                  "assets/icons/logo.png",
                  height: size.height * 0.13,
                ),
                SizedBox(height: size.height * 0.06),
                RoundedInputField(
                  hintText: "Nhập Số điện thoại",
                  icon: FontAwesomeIcons.phone,
                  keyboardType: TextInputType.number,
                  controller: _usernameController,
                  showClearIcon: havePhone,
                  onTapClearIcon: ()=>{_usernameController.clear(),setState(() {havePhone=false;})},
                  onChanged: (value) {
                    value!=''?setState(() {havePhone=true;}):setState(() {havePhone=false;});
                  },
                ),
                RoundedPasswordField(
                  hintText: "Nhập mật khẩu",
                  obscureText: notSeePassword,
                  icon: FontAwesomeIcons.lock,
                  controller: _passwordController,
                  showClearIcon: havePass,
                  onTapClearIcon: ()=>{_passwordController.clear(),setState(() {havePass=false;})},
                  switchObscureTextMode: ()=>{
                    notSeePassword==true?setState((){notSeePassword=false;}):setState((){notSeePassword=true;})
                  },
                  onChanged: (value) {
                    value!=''?setState(() {havePass=true;}):setState(() {havePass=false;});
                  },
                  onSubmitted: (value)=>{
                    _validateCheckActivetedSendCodeAndLoginIfVerifySuccessful(_usernameController.text,_passwordController.text)
                  },
                ),
                SizedBox(height: size.height * 0.01),
                RoundedButton(
                  text: "Đăng nhập",
                  press: () {
                    _validateCheckActivetedSendCodeAndLoginIfVerifySuccessful(_usernameController.text,_passwordController.text);
                  },
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()=>{
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => ForgotPasswordScreen()))
                      },
                      child: Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          color: kPrimaryHighLightColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => SignUpScreen()));
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  width: size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Hoặc",
                          style: TextStyle(
                            color: kPrimaryHighLightColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: ()=>{
                    _loginFacebook()
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: kPrimaryLightColor,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/icons/facebook.png",
                      height: size.height * 0.06,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

  void _setBaseUrl() {
    var focusNode = FocusNode();
    focusNode.requestFocus();
    TextEditingController text = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      RoundedInputField(
                        icon: Icons.star_border_rounded,
                        hintText: 'Base Url',
                        keyboardType: TextInputType.name,
                        focusNode: focusNode,
                        showClearIcon: true,
                        controller: text,
                        clearIcon: Icons.send_rounded,
                        onTapClearIcon: ()=>{
                          setBaseUrl(text.text),
                          Navigator.pop(context),
                        },
                        onChanged: (value) {},
                        onSubmitted: (value)=>{
                          setBaseUrl(text.text),
                          Navigator.pop(context),
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

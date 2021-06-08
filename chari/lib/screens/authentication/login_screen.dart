import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chari/services/services.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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

  _signInFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();

    final result = await facebookLogin.logIn(['email']);
    final fb_token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name&access_token=${fb_token}');
    var fbUser = json.decode(utf8.decode(graphResponse.bodyBytes));
    print(fbUser);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('fb_token',fb_token);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(accessToken: fb_token);
      _firebaseAuth.signInWithCredential(credential);
    }

    var res = await API.loginFB(fbUser['name'], fbUser['id']);
    _saveDeviceToken(fbUser['id']);
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
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jsRes['token']); //{sub: 0973465515, exp: 19609229038, iat: 1609229038}
        DateTime expirationDate = JwtDecoder.getExpirationDate(jsRes['token']);
        print("Token sẽ hết hạn vào: "+expirationDate.toString());

        _prefs.setString('token',jsRes['token']);
        _prefs.setString('username',decodedToken['sub']);

        var jsRes2;
        var res2 = await API.getDonatorDetailsByFacebookId(fbUser['id'],_prefs.getString('token'));
        jsRes2 = json.decode(utf8.decode(res2.bodyBytes));

        _prefs.setInt('donator_id',jsRes2['dnt_ID']);
        if(jsRes2['address']==null){
          _prefs.setString('donator_address','');
        }else{
          _prefs.setString('donator_address',jsRes2['address'].toString());
        }

        if(jsRes2['fullName']==null){
          _prefs.setString('donator_full_name','');
        }else{
          _prefs.setString('donator_full_name',jsRes2['fullName'].toString());
        }

        if(jsRes2['avatarUrl']==null){
          _prefs.setString('donator_avatar_url','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/charity_avatar.jpeg?alt=media&token=e339794b-3625-452b-a170-02f0874d5363');
        }else{
          _prefs.setString('donator_avatar_url',jsRes2['avatarUrl'].toString());
        }

        if(jsRes2['facebookId']==null){
          _prefs.setString('donator_facebook_id','');
        }else{
          _prefs.setString('donator_facebook_id',jsRes2['facebookId'].toString());
        }

        if(jsRes2['phoneNumber']==null){
          _prefs.setString('donator_phone','');
        }else{
          _prefs.setString('donator_phone',jsRes2['phoneNumber'].toString());
        }

        _prefs.setString('donator_favorite_project',jsRes2['favoriteProject'].toString());
        _prefs.setString('donator_favorite_notification',jsRes2['favoriteNotification'].toString());
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> AppBarScreen()), (Route<dynamic> route) => false);
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
    var res = await API.signin(username, password);
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
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jsRes['token']); //{sub: 0973465515, exp: 19609229038, iat: 1609229038}
        DateTime expirationDate = JwtDecoder.getExpirationDate(jsRes['token']);
        print("Token sẽ hết hạn vào: "+expirationDate.toString()); //Hết hạn vào:

        // lưu token vào SharedPreferences
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('token',jsRes['token']);
        _prefs.setString('username',decodedToken['sub']);
        _prefs.setString('password',password);

        // Lưu thông tin người dùng đã đăng nhập... Vì lúc tạo người dùng mới, app đang dùng là app của donator, phía server sẽ lưu đồng thời cả app user và thông tin của donator,
        // lúc đăng ký lần đầu thì thông tin của donator chỉ có mỗi số điện thoại
        var jsRes2;
        var res2 = await API.getDonatorDetailsByPhone(username,_prefs.getString('token'));
        jsRes2 = json.decode(utf8.decode(res2.bodyBytes));
        _prefs.setInt('donator_id',jsRes2['dnt_ID']);
        if(jsRes2['address']==null){_prefs.setString('donator_address','');
        }else{_prefs.setString('donator_address',jsRes2['address'].toString());
        }if(jsRes2['fullName']==null){_prefs.setString('donator_full_name','');
        }else{_prefs.setString('donator_full_name',jsRes2['fullName'].toString());
        }if(jsRes2['avatarUrl']==null){_prefs.setString('donator_avatar_url','https://1.bp.blogspot.com/-kFguDxc0qe4/XyzyK1y6eiI/AAAAAAAAwW8/XcAuOQ2qvQYhoDe4Bv0eLX9eye7FnmKKgCLcBGAsYHQ/s1600/co-4-la%2B%25283%2529.jpg');
        }else{_prefs.setString('donator_avatar_url',jsRes2['avatarUrl'].toString());
        }
        if(jsRes2['facebookId']==null){
          _prefs.setString('donator_facebook_id','');
        }else{
          _prefs.setString('donator_facebook_id',jsRes2['facebookId'].toString());
        }

        if(jsRes2['phoneNumber']==null){
          _prefs.setString('donator_phone','');
        }else{
          _prefs.setString('donator_phone',jsRes2['phoneNumber'].toString());
        }

        _prefs.setString('donator_favorite_project',jsRes2['favoriteProject'].toString());
        _prefs.setString('donator_favorite_notification',jsRes2['favoriteNotification'].toString());

        //Chuyển hướng đến trang chính và xóa tất cả context trước đó
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> AppBarScreen()), (Route<dynamic> route) => false);
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
    API.saveFCMToken(username, fcmToken);
  }


  //Hàm kiểm tra định dạng đầu vào -> xem tài khoản đã được xác nhận hay chưa -> nếu chưa thì gửi code -> nếu xác thực thành công thì thực hiện đăng nhập
  _validateCheckActivetedSendCodeAndLoginIfVerifireSuccessful(String username, String password) async{
    String error_message='';
    if(username.length != 0 && password.length !=0) {
      if(username.length==10 && CheckString.onlyNumber(username)){
        if(CheckString.isMyCustomPassword(password)){
          var res = await API.signin(username, password);
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
            await API.activateUser(NavitePhone);
            await API.saveUser(NavitePhone);
            _login(_usernameController.text,_passwordController.text);
          }).catchError((e) {
            return "error";
          });
        },
        verificationFailed: (AuthException exception) {
          Fluttertoast.showToast(
              msg: "Xác thực thất bại!\nSĐT không tồn tại hoặc Đã quá số lần xác thực quy định!\nHãy quay lại sau 24 giờ!",
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
            await API.activateUser(NavitePhone);
            await API.saveUser(NavitePhone);
            _login(_usernameController.text,_passwordController.text);
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
          "Đăng nhập",
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
                  onTapClearIcon: ()=>{_usernameController.clear()},
                  onChanged: (value) {},
                ),
                RoundedPasswordField(
                  hintText: "Nhập mật khẩu",
                  obscureText: notSeePassword,
                  icon: FontAwesomeIcons.lock,
                  controller: _passwordController,
                  onTapClearIcon: ()=>{_passwordController.clear()},
                  switchObscureTextMode: ()=>{
                    if(notSeePassword==true){
                      setState((){notSeePassword=false;})
                    }else{
                      setState((){notSeePassword=true;})
                    }
                  },
                  onChanged: (value) {},
                ),
                SizedBox(height: size.height * 0.01),
                RoundedButton(
                  text: "Đăng nhập",
                  press: () {
                    _validateCheckActivetedSendCodeAndLoginIfVerifireSuccessful(_usernameController.text,_passwordController.text);
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
                    _signInFacebook()
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
}

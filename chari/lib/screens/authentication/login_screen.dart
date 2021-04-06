import 'dart:convert';

import 'package:chari/API.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
    _LoginScreenState createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool notSeePassword = true;


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
        _prefs.setString('donator_phone',jsRes2['phoneNumber'].toString());
        _prefs.setString('donator_favorite_project',jsRes2['favoriteProject'].toString());

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
            //Khi đăng nhập với tài khoản chưa được xác nhận
            if(jsRes['data']['status']=='NOT-ACTIVATED') {
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
              _login(_usernameController.text,_passwordController.text);
            }
          }else{
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
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Đăng nhập",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/icons/login.png",
                  height: size.height * 0.2,
                ),
                SizedBox(height: size.height * 0.03),
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
                          color: kPrimaryColor,
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
              ],
            ),
          ),
        ),
    );
  }
}


import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/async.dart';

class EnterCodeScreen extends StatefulWidget {
  final String phone;
  String verificationId;
  final FirebaseAuth firebaseAuth;
  EnterCodeScreen({@required this.phone,this.verificationId,this.firebaseAuth});
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeController = TextEditingController();
  var focusNode = FocusNode();
  bool isCodeOverdue=false;
  bool haveEnterCode=false;
  int _start = 120;
  int _current = 120;



  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);

    sub.onData((duration) {
      setState(() { _current = _start - duration.elapsed.inSeconds; });
    });

    sub.onDone(() {
      setState(() {
        isCodeOverdue=true;
      });
      Fluttertoast.showToast(
          msg: 'Mã xác thực hết hiệu lực',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
      sub.cancel();
    });
  }


  @override
  void initState() {
    super.initState();
    startTimer();
    focusNode.requestFocus();

  }

  @override
  void dispose() {
    super.dispose();
    setState(() { _current = 0; });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String NavitePhone="0"+widget.phone.substring(3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Xác thực OPT',
          style: const TextStyle(
            color: kPrimaryHighLightColor,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
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
              Text(
                "Mã xác thực đã được gửi về số điện thoại",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryHighLightColor,
                  fontSize: 15,
                ),
              ),
              Text(
                NavitePhone,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryHighLightColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Hãy nhập mã xác thực ở trong tin nhắn của bạn",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryHighLightColor,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                textAlign: TextAlign.center,
                focusNode: focusNode,
                hintText: "Nhập mã xác nhận",
                icon: FontAwesomeIcons.key,
                keyboardType: TextInputType.number,
                controller: _codeController,
                showClearIcon: haveEnterCode,
                onTapClearIcon: ()=>{_codeController.clear(),setState(() {haveEnterCode=false;})},
                onChanged: (value) {
                  value!=''?setState(() {haveEnterCode=true;}):setState(() {haveEnterCode=false;});
                },
              ),
              RoundedButton(
                text: isCodeOverdue?"Gửi lại mã":"Xác nhận $_current",
                press:() {
                  isCodeOverdue?resendCode():verifyCode();
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  
  resendCode() async{
    print('resending code!');
    await widget.firebaseAuth.verifyPhoneNumber(
      phoneNumber: widget.phone,
      timeout: Duration(seconds: 120),
      verificationFailed: (AuthException e) {
        String msg;
        if(e.code != 'invalid-phone-number') {
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
      codeSent: (String verificationId, [int]) async {
        widget.verificationId=verificationId;
        Fluttertoast.showToast(
            msg: 'Đã gửi lại mã xác thực',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kPrimaryHighLightColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
        setState(() {
          isCodeOverdue=false;
          _start=120;
          _current=120;
        });
        startTimer();
      },
    );
  }
  verifyCode(){
    var _credential = PhoneAuthProvider.getCredential(verificationId: widget.verificationId, smsCode: _codeController.text.trim());
    widget.firebaseAuth.signInWithCredential(_credential).then((AuthResult result){
      Navigator.pop(context, 'successful'); //Trả về value khi xác thực thành công
      Fluttertoast.showToast(
          msg: 'Xác thực thành công!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return "successful";
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "Xác thực thất bại!\nMã xác nhận không chính xác!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return "error";
    });
  }
}
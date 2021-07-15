
import 'package:chari/models/models.dart';
import 'package:chari/screens/personal/update_info.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PersonalScreen extends StatefulWidget {
  Donator donator;
  List<PushNotification> push_notification_list;
  PersonalScreen({Key key, @required this.donator,this.push_notification_list}) : super(key: key);
  @override
  _PersonalScreenState createState()=> _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {

  String fullname;
  String address;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();

  initState(){
    _getDonatorDetails();
    print(widget.donator.username);
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  Future<void> fbLogOut() async {
    await _firebaseAuth.signOut().then((onValue) {
      setState(() {
        facebookLogin.logOut();
      });
    });
  }

  _getDonatorDetails() async {
    setState(() {
      fullname = widget.donator.full_name;
      address = widget.donator.address;
    });
  }


  _showChangeInformationDialog(BuildContext context) {
    Future<String> future = showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (BuildContext context){
          return UpdateInfoScreen(donator: widget.donator);
        }
    );
    future.then((String value) => _closeUpdateInfoModal(value));
  }
  _closeUpdateInfoModal(String value) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    if(value=='updated'){
      setState(() {
        fullname = p.getString('donator_full_name');
        address = p.getString('donator_address');
        widget.donator.full_name=fullname;
        widget.donator.address=address;
      });
    }
  }

  _showSendFeedbackDialog(BuildContext context) {
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
          return SendFeedbackScreen(donator:widget.donator);
        }
    );
  }
  _showSendRecommedSupportedPeople(BuildContext context) {
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
          return SendRecommendInfoScreen(donator:widget.donator);
        }
    );
  }

  _showChangePasswordDialog(String username,String password,BuildContext context) {
    //Stateless example

    // TextEditingController _curPasswordField = TextEditingController();
    // TextEditingController _newPasswordField = TextEditingController();
    // TextEditingController _reWritePasswordField = TextEditingController();
    // bool notSeePassword = true;
    // bool notSeePassword1 = true;
    // bool notSeePassword2 = true;
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
          return Wrap(
            children: [
              //Stateless example

              // Container(
              //   padding: EdgeInsets.only(right: 24, left: 24, top: 32, bottom: 24),
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: <Widget>[
              //         Text("Đổi mật khẩu",
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //             color: kPrimaryHighLightColor,
              //           ),
              //         ),
              //         SizedBox(height: 5),
              //         Container(
              //           height: 1.5,
              //           color: Colors.grey[300],
              //           margin: EdgeInsets.symmetric(horizontal: 0),
              //         ),
              //         TextFieldContainer(
              //           child: Text('Mật khẩu mới phải thỏa các điều kiện sau\n- Phải khác mật khẩu cũ\n- Phải có 8 đến 15 ký tự\n- Phải có ít nhất 1 ký tự số và 1 ký tự chữ\nVí dụ: aqk153 hoặc 153aqk',
              //               style: TextStyle(
              //                 color: kPrimaryHighLightColor,
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.normal,
              //               )),
              //         ),
              //         RoundedPasswordField(
              //           hintText: "Mật khẩu hiện tại",
              //           icon: FontAwesomeIcons.unlock,
              //           obscureText: notSeePassword,
              //           controller: _curPasswordField,
              //           onTapClearIcon: ()=>{_curPasswordField.clear()},
              //           switchObscureTextMode: ()=>{
              //             if(notSeePassword==true){
              //               setState((){notSeePassword=false;})
              //             }else{
              //               setState((){notSeePassword=true;})
              //             }
              //           },
              //           onChanged: (value) {},
              //         ),
              //         RoundedPasswordField(
              //           hintText: "Mật khẩu mới",
              //           icon: FontAwesomeIcons.lockOpen,
              //           obscureText: notSeePassword1,
              //           controller: _newPasswordField,
              //           onTapClearIcon: ()=>{_newPasswordField.clear()},
              //           switchObscureTextMode: ()=>{
              //             if(notSeePassword1==true){
              //               setState((){notSeePassword1=false;})
              //             }else{
              //               setState((){notSeePassword1=true;})
              //             }
              //           },
              //           onChanged: (value) {},
              //         ),
              //         RoundedPasswordField(
              //           hintText: "Nhập lại mật khẩu mới",
              //           icon: FontAwesomeIcons.lock,
              //           obscureText: notSeePassword2,
              //           controller: _reWritePasswordField,
              //           onTapClearIcon: ()=>{_reWritePasswordField.clear()},
              //           switchObscureTextMode: ()=>{
              //             if(notSeePassword2==true){
              //               setState((){notSeePassword2=false;})
              //             }else{
              //               setState((){notSeePassword2=true;})
              //             }
              //           },
              //           onChanged: (value) {},
              //         ),
              //         RoundedButton(
              //           text: "Xác nhận",
              //           press: ()=>{
              //             _changePassword(username,password,_curPasswordField.text,_newPasswordField.text,_reWritePasswordField.text)
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              //User Stateful widget
              ChangePasswordScreen(username:username,password:password),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(),
          Expanded(
            child: SingleChildScrollView(
              child:  Column(
                  children: [
                    SizedBox(height: kSpacingUnit.toDouble() * 2),
                    Container(
                      height: kSpacingUnit.toDouble() * 15,
                      width: kSpacingUnit.toDouble() * 15,
                      margin: EdgeInsets.only(top: kSpacingUnit.toDouble() * 3),
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: kSpacingUnit.toDouble() * 15,
                            backgroundImage: NetworkImage(widget.donator.avatar_url)
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kSpacingUnit.toDouble() * 2),
                    Text(
                      this.fullname,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: kSpacingUnit.toDouble() * 0.5),
                    Text(
                      widget.donator.phone_number,
                      style: TextStyle(
                        fontSize: kSpacingUnit.toDouble() * 1.7,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: kSpacingUnit.toDouble() * 5),
                    RoundedButton(
                      text: 'Đóng góp ý kiến',
                      color: kPrimaryLightColor,
                      textColor: kPrimaryHighLightColor,
                      fontsize: 17,
                      press: ()=>{
                       _showSendFeedbackDialog(context)
                      },
                    ),
                    RoundedButton(
                      text: 'Giới thiệu hoàn cảnh',
                      color: kPrimaryLightColor,
                      textColor: kPrimaryHighLightColor,
                      fontsize: 17,
                      press: ()=>{
                        _showSendRecommedSupportedPeople(context)
                      },
                    ),
                    RoundedButton(
                      text: 'Cập nhật thông tin',
                      color: kPrimaryLightColor,
                      textColor: kPrimaryHighLightColor,
                      fontsize: 17,
                      press: ()=>{
                        _showChangeInformationDialog(context)
                      },
                    ),
                    if(widget.donator.username.length==10)
                      RoundedButton(
                        text: 'Đổi mật khẩu',
                        color: kPrimaryLightColor,
                        textColor: kPrimaryHighLightColor,
                        fontsize: 17,
                        press: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          _showChangePasswordDialog(prefs.getString('username'),prefs.getString('password'),context);
                        },
                      ),
                    RoundedButton(
                      text: 'Đăng xuất',
                      fontsize: 17,
                      press: () {
                        _logOut();
                      },
                    ),
                  ]
              )
            ),
          ),
        ],
      ),
    );
  }

  _logOut() async{
    fbLogOut();
    SharedPreferences p = await SharedPreferences.getInstance();
    UserService.saveFCMToken(p.getString('username'), null);
    for(int i=0;i<widget.push_notification_list.length;i++){
      _fcm.unsubscribeFromTopic(widget.push_notification_list.elementAt(i).topic.toString());
    }
    p.setString('token','');
    p.setString('fb_token','');
    p.setInt('donator_id',null);
    p.setString('donator_full_name','');
    p.setString('donator_address','');
    p.setString('donator_phone','');
    p.setString('donator_facebook_id','');
    p.setString('donator_avatar_url','');
    p.setString('donator_favorite_project','');
    p.setString('donator_favorite_notification','');
    p.setBool('favorite',false);
    p.setString('donatorFavorite','*');
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext ctx) => MainScreen()));
  }
}
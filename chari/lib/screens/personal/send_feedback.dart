import 'dart:convert';

import 'package:chari/models/models.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SendFeedbackScreen extends StatefulWidget {
  Donator donator;
  SendFeedbackScreen({Key key, @required this.donator}) : super(key: key);
  @override
  _SendFeedbackScreenState createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  var focusNode = FocusNode();
  bool haveTitle = false;
  bool haveContent = false;
  TextEditingController _titleField = TextEditingController();
  TextEditingController _descriptionField = TextEditingController();

  @override
  initState() {
    super.initState();
    focusNode.requestFocus();
  }

  validateAndSendFeedback(String contributor,String title,String description,BuildContext context) async{
    String message;
    int errorCode;
    if(description.length != 0) {
      var jsonResponse;
      var res = await FeedbackService.sendFeedback(contributor,widget.donator.phone_number, title, description, widget.donator.token);
      jsonResponse = json.decode(utf8.decode(res.bodyBytes));
      message = jsonResponse['message'];
      errorCode = jsonResponse['errorCode'];
      Navigator.pop(context);
    }else{
      message='Bạn hãy điền thông tin ở ô Nội dung!';
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: errorCode==0 ? kPrimaryColor : Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return errorCode;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 0),
      child: Stack(
        children: [
          Positioned(
            right: size.width*0.35,top:-28,
            child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                Text("Đóng góp ý kiến",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryHighLightColor,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 1.5,
                  color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 0),
                ),
                SizedBox(height: 5),
                Column(
                  children: [
                    RoundedInputField(
                      icon: Icons.adjust,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      controller: _titleField,
                      showClearIcon: haveTitle,
                      onTapClearIcon: ()=>{_titleField.clear(),setState(() {haveTitle=false;})},
                      hintText: 'Tiêu đề',
                      onChanged: (value) {
                        value!=''?setState(() {haveTitle=true;}):setState(() {haveTitle=false;});
                      },
                    ),
                    RoundedInputField(
                      icon: Icons.message,
                      keyboardType: TextInputType.text,
                      controller: _descriptionField,
                      showClearIcon: haveContent,
                      onTapClearIcon: ()=>{_descriptionField.clear(),setState(() {haveContent=false;})},
                      hintText: 'Nội dung đóng góp',
                      onChanged: (value) {
                        value!=''?setState(() {haveContent=true;}):setState(() {haveContent=false;});
                      },
                    ),
                    RoundedButton(
                      text: "Xác nhận",
                      press: ()async{
                        SharedPreferences _prefs = await SharedPreferences.getInstance();
                        validateAndSendFeedback(_prefs.getString('donator_full_name'),_titleField.text,_descriptionField.text,context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
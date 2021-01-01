import 'dart:convert';

import 'package:charity_donator_app/API.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackService{
  static showSendFeedbackDialog(BuildContext context) {
    TextEditingController _titleField = TextEditingController();
    TextEditingController _descriptionField = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Đóng góp ý kiến",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 1.5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 5),

                    RoundedInputField(
                      icon: Icons.adjust,
                      keyboardType: TextInputType.text,
                      controller: _titleField,
                      onTopClearIcon: ()=>{_titleField.clear()},
                      hintText: 'Tiêu đề',
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      icon: Icons.message,
                      keyboardType: TextInputType.text,
                      controller: _descriptionField,
                      onTopClearIcon: ()=>{_descriptionField.clear()},
                      hintText: 'Nội dung đóng góp',
                      onChanged: (value) {},
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
              ),
            ),
          );
        });
  }

  static validateAndSendFeedback(String contributor,String title,String description,BuildContext context) async{
    String message;
    int errorCode;
    if(description.length != 0) {
      String url = baseUrl+"/feedbacks";
      final body = jsonEncode(<String, String>{
        "contributor":contributor,
        "title":title,
        "description":description
      });
      var jsonResponse;
      var res = await http.post(url,headers:header,body: body);
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
        backgroundColor: errorCode==0 ? Colors.green : Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return errorCode;
  }
}
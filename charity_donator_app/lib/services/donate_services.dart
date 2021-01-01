import 'dart:convert';

import 'package:charity_donator_app/API.dart';
import 'package:charity_donator_app/constants.dart';
import 'package:charity_donator_app/models/models.dart';
import 'package:charity_donator_app/screens/screens.dart';
import 'package:charity_donator_app/utility/utility.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DonateService{
  static showDonateDialog(BuildContext context,Project project) {
    TextEditingController _moneyControllerField = TextEditingController();
    TextEditingController _messageControllerField = TextEditingController();
    String str_donate_money="";
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
                    Text(project.project_name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(height: 1.5,color: Colors.grey[300],margin: EdgeInsets.symmetric(horizontal: 0),),
                    SizedBox(height: 10),
                    Text("Phương thức thanh toán"),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.paypal), onPressed: () {  },
                      color: Colors.blueAccent,
                      iconSize: 40,
                    ),
                    Container(height: 1.5,color: Colors.grey[300],margin: EdgeInsets.symmetric(horizontal: 0),),
                    SizedBox(height: 10),
                    CustomCheckBoxGroup(
                      buttonTextStyle: ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: Colors.black,
                        textStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      autoWidth: false,
                      enableButtonWrap: true,
                      wrapAlignment: WrapAlignment.center,
                      unSelectedColor: Theme.of(context).canvasColor,
                      buttonLables: ["10k","20k","50k","100k","200k","500k",],
                      buttonValuesList: [10000,20000,50000,100000,200000,500000,],
                      checkBoxButtonValues: (values) {
                        int selected_money=0;
                        values.forEach((i) {selected_money+=i; });
                        _moneyControllerField.text=selected_money.toString();
                        str_donate_money=selected_money.toString();
                      },
                      defaultSelected: null,
                      horizontal: false,
                      width: 80,
                      selectedColor: kPrimaryColor,
                      padding: 5,
                      enableShape: true,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text("Số tiền: "+MoneyUtility.numberToString(str_donate_money)+"đồng"),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "Số tiền",
                      icon: Icons.favorite,
                      keyboardType: TextInputType.number,
                      controller: _moneyControllerField,
                      onTopClearIcon: ()=>{
                        _moneyControllerField.clear(),
                        str_donate_money = '',

                      },
                      onChanged: (value) {
                        str_donate_money=value;
                        if(CheckString.onlyNumber(value.toString())==false){
                          _moneyControllerField.clear();
                          str_donate_money='';
                          Fluttertoast.showToast(
                              msg: 'Không đúng định dạng!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.orangeAccent,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        if(int.tryParse(value) > 1000000000){
                          _moneyControllerField.clear();
                          str_donate_money='';
                          Fluttertoast.showToast(
                              msg: 'Số tiền quá lớn!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.orangeAccent,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        },
                    ),
                    RoundedInputField(
                      hintText: "Lời nhắn",
                      icon: Icons.messenger_outline,
                      keyboardType: TextInputType.text,
                      controller: _messageControllerField,
                      onTopClearIcon: ()=>{_messageControllerField.clear()},
                      onChanged: (value) {},
                    ),
                    RoundedButton(
                      text: "Ủng hộ",
                      press: ()async{
                        int lessMoney=project.target_money-project.cur_money;
                        String message="";
                        int errorCode=-1;
                        if(_moneyControllerField.text.length != 0){
                          if(int.parse(_moneyControllerField.text) >= 1000){
                            if(int.parse(_moneyControllerField.text)<=lessMoney && int.parse(_moneyControllerField.text) <= 1000000000){
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int donator_id = prefs.getInt('donator_id');
                              if(donator_id==null){donator_id = -1;}  //nếu chưa đăng nhập***** Vấn đề là lỡ có nhiều lượt quyên góp ko đăng nhập thì sao ******
                              String url = baseUrl+"/paypal/donator_id/${donator_id}/project_id/${project.prj_id}/donate";
                              final body = jsonEncode(<String, String>{
                                "price": _moneyControllerField.text,
                                "description":_messageControllerField.text
                              });
                              var res = await http.post(url,headers:header,body: body);
                              Navigator.pop(context);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context)=>DonateScreen(paypalurl: res.body.toString(),project: project, money: _moneyControllerField.text,))
                              );
                            }else{
                              message='Dự án này chỉ cần ${lessMoney} VNĐ nữa là đủ!';
                              errorCode=0;
                            }}else{
                            message  = 'Hãy ủng hộ ít nhất 1.000 VNĐ!';
                          }}else{
                          message  = 'Hãy nhập số tiền đúng định dạng!';
                        }
                        if(message.length>0){
                          Fluttertoast.showToast(
                              msg: message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: errorCode==0?Colors.green:Colors.orangeAccent,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
import 'dart:convert';

import 'package:chari/API.dart';
import 'file:///D:/HCMUTE/HK8/KLTN-chari/chari/lib/utility/constants.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class DonateScreen extends StatefulWidget {
  final Project project;
  DonateScreen({@required this.project});
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  TextEditingController _moneyControllerField = TextEditingController();
  TextEditingController _messageControllerField = TextEditingController();
  String str_donate_money="";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Quyên góp',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onPressed: () {
              // do something
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(30,10,30,10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(0))),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width - 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.project.image_url),
                          )),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(widget.project.project_name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(height: 1.5,color: Colors.grey[300],margin: EdgeInsets.symmetric(horizontal: 0),),
                    SizedBox(height: size.height * 0.01),
                    Text("Phương thức thanh toán"),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.paypal), onPressed: () {  },
                      color: Colors.blueAccent,
                      iconSize: 40,
                    ),
                    Container(height: 1.5,color: Colors.grey[300],margin: EdgeInsets.symmetric(horizontal: 0),),
                    SizedBox(height: size.height * 0.01),
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
                        setState(() {
                          str_donate_money=selected_money.toString();
                        });
                      },
                      defaultSelected: null,
                      horizontal: false,
                      width: 80,
                      selectedColor: kPrimaryColor,
                      padding: 5,
                      enableShape: true,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text("Số tiền: "+MoneyUtility.numberToString(str_donate_money)+"đồng"),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "Số tiền",
                      icon: Icons.favorite,
                      keyboardType: TextInputType.number,
                      controller: _moneyControllerField,
                      onTapClearIcon: ()=>{
                        _moneyControllerField.clear(),
                        setState(() {
                          str_donate_money = '';
                        }),
                      },
                      onChanged: (value) {
                        setState(() {
                          str_donate_money=value;
                        });
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
                        if(int.tryParse(value) > 20000000){
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
                      onTapClearIcon: ()=>{_messageControllerField.clear()},
                      onChanged: (value) {},
                    ),
                    RoundedButton(
                      text: "Ủng hộ",
                      press: ()async{
                        int lessMoney=widget.project.target_money-widget.project.cur_money;
                        String message="";
                        int errorCode=-1;
                        if(_moneyControllerField.text.length != 0){
                          if(int.parse(_moneyControllerField.text) >= 1000){
                            if(int.parse(_moneyControllerField.text)<=lessMoney && int.parse(_moneyControllerField.text) <= 1000000000){
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int donator_id = prefs.getInt('donator_id');
                              if(donator_id==null){donator_id = -1;}  //nếu chưa đăng nhập***** Vấn đề là lỡ có nhiều lượt quyên góp ko đăng nhập thì sao ******
                              String url = baseUrl+"/paypal/donator_id/${donator_id}/project_id/${widget.project.prj_id}/donate";
                              final body = jsonEncode(<String, String>{
                                "price": _moneyControllerField.text,
                                "description":_messageControllerField.text
                              });
                              var res = await http.post(url,headers:header,body: body);
                              Navigator.pop(context);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context)=>DonateWithPaypalWebViewScreen(paypalurl: res.body.toString(),project: widget.project, money: _moneyControllerField.text,))
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
                              backgroundColor: errorCode==0?kPrimaryColor:Colors.orangeAccent,
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
          )
        ],
      ),
    );
  }

}
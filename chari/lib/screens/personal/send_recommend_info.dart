import 'dart:convert';

import 'package:chari/models/models.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SendRecommendInfoScreen extends StatefulWidget {
  Donator donator;
  SendRecommendInfoScreen({Key key, @required this.donator}) : super(key: key);
  @override
  _SendRecommendInfoScreenState createState() => _SendRecommendInfoScreenState();
}

class _SendRecommendInfoScreenState extends State<SendRecommendInfoScreen> {
  var focusNode = FocusNode();

  bool _haveName = false;
  bool _haveContent = false;
  bool _havePhone = false;
  bool _haveAddress = false;
  bool _haveBankName = false;
  bool _haveBankAccount = false;

  TextEditingController _nameField = TextEditingController();
  TextEditingController _descriptionField = TextEditingController();
  TextEditingController _phoneField = TextEditingController();
  TextEditingController _addressField= TextEditingController();
  TextEditingController _bankNameField = TextEditingController();
  TextEditingController _bankAccountField = TextEditingController();

  @override
  initState() {
    super.initState();
    focusNode.requestFocus();
  }
  validateAndSendPeopleRecommend(String description,String fullName,String address,String phoneNumber,String bankName,String bankAccount,BuildContext context) async{
    String message;
    int errorCode;
    if(description.length != 0 && fullName.length !=0) {
      var jsonResponse;
      var res = await RecommendSupportedPeople.sendInformation(widget.donator.full_name,widget.donator.phone_number, description,
                                                              fullName,address,phoneNumber,bankName,bankAccount,widget.donator.token);
      jsonResponse = json.decode(utf8.decode(res.bodyBytes));
      message = jsonResponse['message'];
      errorCode = jsonResponse['errorCode'];
      Navigator.pop(context);
    }else{
      message='Hãy cung cấp mô tả hoàn cảnh và tên người cần được hỗ trợ!';
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
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
                Text("Giới thiệu hoàn cảnh",
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
                      icon: Icons.message,
                      keyboardType: TextInputType.text,
                      controller: _descriptionField,
                      showClearIcon: _haveContent,
                      onTapClearIcon: ()=>{_descriptionField.clear(),setState(() {_haveContent=false;})},
                      hintText: 'Mô tả hoàn cảnh',
                      hintSize: 14,
                      onChanged: (value) {
                        value!=''?setState(() {_haveContent=true;}):setState(() {_haveContent=false;});
                      },
                    ),
                    RoundedInputField(
                      icon: Icons.adjust,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      controller: _nameField,
                      showClearIcon: _haveName,
                      onTapClearIcon: ()=>{_nameField.clear(),setState(() {_haveName=false;})},
                      hintText: 'Tên người cần hỗ trợ',
                      hintSize: 14,
                      onChanged: (value) {
                        value!=''?setState(() {_haveName=true;}):setState(() {_haveName=false;});
                      },
                    ),
                    RoundedInputField(
                      icon: Icons.phone,
                      keyboardType: TextInputType.text,
                      controller: _phoneField,
                      showClearIcon: _havePhone,
                      onTapClearIcon: ()=>{_phoneField.clear(),setState(() {_havePhone=false;})},
                      hintText: 'SĐT của người cần hỗ trợ',
                      hintSize: 14,
                      onChanged: (value) {
                        value!=''?setState(() {_havePhone=true;}):setState(() {_havePhone=false;});
                      },
                    ),
                    RoundedInputField(
                      icon: Icons.location_on_outlined,
                      keyboardType: TextInputType.text,
                      controller: _addressField,
                      showClearIcon: _haveAddress,
                      onTapClearIcon: ()=>{_addressField.clear(),setState(() {_haveAddress=false;})},
                      hintText: 'Địa chỉ của người cần hỗ trợ',
                      hintSize: 14,
                      onChanged: (value) {
                        value!=''?setState(() {_haveAddress=true;}):setState(() {_haveAddress=false;});
                      },
                    ),
                    RoundedInputField(
                      icon: Icons.comment_bank_outlined,
                      keyboardType: TextInputType.text,
                      controller: _bankNameField,
                      showClearIcon: _haveBankName,
                      onTapClearIcon: ()=>{_bankNameField.clear(),setState(() {_haveBankName=false;})},
                      hintText: 'Tên ngân hàng (nếu có)',
                      hintSize: 14,
                      onChanged: (value) {
                        value!=''?setState(() {_haveBankName=true;}):setState(() {_haveBankName=false;});
                      },
                    ),
                    RoundedInputField(
                      icon: Icons.attach_money_rounded,
                      keyboardType: TextInputType.text,
                      controller: _bankAccountField,
                      showClearIcon: _haveBankAccount,
                      onTapClearIcon: ()=>{_bankAccountField.clear(),setState(() {_haveBankAccount=false;})},
                      hintText: 'Số tài khoản ngân hàng (nếu có)',
                      hintSize: 14,
                      onChanged: (value) {
                        value!=''?setState(() {_haveBankAccount=true;}):setState(() {_haveBankAccount=false;});
                      },
                    ),
                    RoundedButton(
                      text: "Xác nhận",
                      press: ()=>{
                        validateAndSendPeopleRecommend(_descriptionField.text,_nameField.text,_addressField.text,_phoneField.text,_bankNameField.text,_bankAccountField.text,context)
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

import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/constants.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 300),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Center(
                              child: Column(
                                children: [
                                  RoundedButton(
                                    textColor: kPrimaryHighLightColor,
                                    text: "Đóng góp ý kiến",
                                    color: kPrimaryLightColor,
                                    fontsize: 16,
                                    press: (){
                                      FeedBackService.showSendFeedbackDialog(context);
                                      //Navigator.pop(context);
                                    },
                                  ),
                                  RoundedButton(
                                    textColor: kPrimaryHighLightColor,
                                    text: "Đăng ký",
                                    color: kPrimaryLightColor,
                                    fontsize: 16,
                                    press: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => SignUpScreen()));
                                    },
                                  ),
                                  RoundedButton(
                                    text: "Đăng nhập",
                                    fontsize: 16,
                                    press: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
                                    },
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
            ]),
          )
      ),
    );
  }
}

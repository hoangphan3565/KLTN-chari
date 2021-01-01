
import 'package:charity_donator_app/screens/screens.dart';
import 'package:charity_donator_app/services/services.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
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
                                  Text("Để thực hiện chức năng này hãy đăng nhập",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RoundedButton(
                                    text: "Đăng nhập",
                                    fontsize: 16,
                                    press: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Text("Nếu chưa có tài khoản đăng ký ngay tại đây"),
                                  RoundedButton(
                                    text: "Đăng ký",
                                    fontsize: 16,
                                    press: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => SignUpScreen()));
                                    },
                                  ),
                                  Text("Hoặc có thể đóng góp ý kiến tại đây"),
                                  RoundedButton(
                                    text: "Đóng góp ý kiến",
                                    fontsize: 16,
                                    press: (){
                                      FeedBackService.showSendFeedbackDialog(context);
                                      //Navigator.pop(context);
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

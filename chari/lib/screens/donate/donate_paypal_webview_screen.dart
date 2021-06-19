


import 'package:chari/models/models.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class  DonateWithPaypalWebViewScreen extends StatefulWidget{
  final String paypalurl;
  final Project project;
  final String money;
  DonateWithPaypalWebViewScreen({@required this.paypalurl,this.project,this.money});
  @override
  _DonateWithPaypalWebViewScreenState createState()=> _DonateWithPaypalWebViewScreenState();
}
class _DonateWithPaypalWebViewScreenState extends State<DonateWithPaypalWebViewScreen>{

  _showDonateSuccessDialog(BuildContext context,Project project) {
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
                    Container(
                      height: MediaQuery.of(context).size.width - 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(project.image_url),
                          )),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Cảm ơn bạn",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text("Bạn vừa ủng hộ cho dự án: "+ project.project_name),
                    SizedBox(height: 20),
                    Text(
                      "Với số tiền: " + MoneyUtility.convertToMoney(widget.money.toString())+" VND",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(
                      text: "Đóng",
                      press: ()async{
                        Navigator.pop(context);
                      },
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }

  _showDonateFailDialog(BuildContext context,Project project) {
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
                    Container(
                      height: MediaQuery.of(context).size.width - 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(project.image_url),
                          )),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Vừa có lỗi xảy ra",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text("Hiện tại bạn chưa thể ủng hộ cho dự án: "+ project.project_name+". Tất cả số tiền giao dịch sẽ được bảo toàn trong tài khoản của ban!"),
                    SizedBox(height: 20),
                    Text(
                      "Chúng tôi xin thành thực xin lỗi vì sự cố này",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(
                      text: "Đóng",
                      press: ()async{
                        Navigator.pop(context);
                      },
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Thanh toán Paypal',
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.timesCircle,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 35),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child:
        WebView(
          onPageFinished: (page) async {
            if(page.contains('/success')){
              Navigator.pop(context);
              _showDonateSuccessDialog(context,widget.project);
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.paypalurl.toString(),
        ),
      ),
    );
  }
}


import 'package:charity_donator_app/models/models.dart';
import 'package:charity_donator_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class  DonateScreen extends StatefulWidget{
  final String paypalurl;
  final Project project;
  final String money;
  DonateScreen({@required this.paypalurl,this.project,this.money});
  @override
  _DonateScreenState createState()=> _DonateScreenState();
}
class _DonateScreenState extends State<DonateScreen>{

  _showDonateSuccessDialog(BuildContext context,Project project) {
    MoneyFormatterOutput fo = new FlutterMoneyFormatter(
        amount: double.tryParse(widget.money),
        settings: MoneyFormatterSettings(
          thousandSeparator: '.',
          decimalSeparator: ',',
        )
    ).output;
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
                          borderRadius: BorderRadius.circular(20),
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
                      "Với số tiền: " + fo.withoutFractionDigits+" VND",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(
                      text: "Xác nhận",
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
                          borderRadius: BorderRadius.circular(20),
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
                    Text("Hiện tại bạn chưa thể ủng hộ cho dự án: "+ project.project_name+". Tất cả số tiền giao dịch sẽ được bảo toàn trong tài khoảng của ban!"),
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
                      text: "Xác nhận",
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
      body: Container(
        margin: EdgeInsets.only(top: 35),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child:
        WebView(
          onPageFinished: (page){
            if(page.contains('/success')){
              Navigator.pop(context); //Đóng webview khi chuyển tiền thành công
              _showDonateSuccessDialog(context,widget.project); //Hiện thông tin đã quyên góp sau khi thanh toán thành công
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.paypalurl.toString(),
        ),
      ),
    );
  }
}
import 'file:///D:/HCMUTE/HK8/KLTN-chari/chari/lib/utility/constants.dart';
import 'package:chari/screens/screens.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: AppBarScreen()
    );
  }
}
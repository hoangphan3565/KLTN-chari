import 'dart:io';

import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
        ..badCertificateCallback=(X509Certificate cert,String host,int port)=> true;
  }
}

void main(){
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

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
      // home: MainScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/project_details': (context) => ProjectDetailsScreen(project_id: 1),
      },
    );
  }
}
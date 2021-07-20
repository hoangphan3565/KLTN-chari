
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'utility/utility.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/material.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainScreen(),
      onGenerateRoute: generateRoute,
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var routingData = settings.name.getRoutingData; // Get the routing Data
    switch (routingData.route) { // Switch on the path from the data
      case '/':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => MainScreen());
      case '/project_detail':
        var id = int.tryParse(routingData['id']);
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => ProjectDetailsScreen(project_id: id));
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => MainScreen());
    }
  }
}


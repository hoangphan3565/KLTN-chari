import 'package:chari/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState()=> _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Thông báo',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 300.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Chưa có thông báo nào!",
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            )
          ],
        ),
    );
  }
}
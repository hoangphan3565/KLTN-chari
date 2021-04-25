import 'package:chari/models/donator_notification.dart';
import 'package:chari/models/project_model.dart';
import 'package:chari/screens/home/projectdetails_screen.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/material.dart';
import '../../API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  final List<DonatorNofitication> donator_notification_list;
  final List<Project> projects;

  NotificationsScreen({Key key, @required this.donator_notification_list,this.projects}) : super(key: key);
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
            color: kPrimaryHighLightColor,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(0))),
                child: CustomScrollView(
                  slivers: <Widget>[
                    widget.donator_notification_list.length == 0 ?
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
                                    color: kPrimaryHighLightColor,
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
                        :
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index){
                          return buildNotificationInfo(widget.donator_notification_list[index]);},
                        childCount:  widget.donator_notification_list.length,
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
    );
  }

  Container buildNotificationInfo(DonatorNofitication nofitication){
    return Container(
      margin: EdgeInsets.fromLTRB(8,5,8,5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  nofitication.title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  nofitication.message,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat('kk:mm dd-MM-yy').format(DateTime.parse(nofitication.date_time)),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          widget.projects.where((p) => p.prj_id==nofitication.project_id).length != 0 ?
          InkWell(
            onTap: ()=>{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: widget.projects.where((p) => p.prj_id==nofitication.project_id).elementAt(0),)),
              ),
            },
            child: Container(
              height: 90,
              width: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
                    image: NetworkImage(widget.projects.where((p) => p.prj_id==nofitication.project_id).elementAt(0).image_url)
                  )),
            ),
          ) :
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/loading.gif")
                  ))
          )

        ],
      ),
    );
  }

}

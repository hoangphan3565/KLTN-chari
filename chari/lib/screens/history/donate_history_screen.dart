
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final List<DonateDetails> donate_details_list;
  final List<Project> projects;
  HistoryScreen({Key key, @required this.donate_details_list,this.projects}) : super(key: key);
  @override
  _HistoryScreenState createState()=> _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2)),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor:  Colors.white,
                centerTitle: false,
                floating: true,
                title: Image.asset(
                    "assets/icons/logo.png",
                    height: size.height * 0.04,
                  ),
                actions: <Widget>[
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      FontAwesomeIcons.search,
                      size: 19,
                    ),
                    onPressed: () {
                      // do something
                    },
                  ),
                ],
              ),
              widget.donate_details_list.length == 0 ?
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
                            "Chưa lịch sử ủng hộ nào!",
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
                    return buildProjectInfo(widget.donate_details_list[index]);},
                  childCount:  widget.donate_details_list.length,
                ),
              )
            ],
          )
      ),
    );
  }

  GestureDetector buildProjectInfo(DonateDetails donate_details){
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: widget.projects.where((p) => p.prj_id==donate_details.project_id).elementAt(0),)),
          );
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(5,5,5,0),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.heart,
                          size: 16,
                          color: kPrimaryHighLightColor,
                        ),
                        Text(
                          " "+MoneyUtility.convertToMoney(donate_details.money.toString())+' đ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        if(donate_details.status=='FAILED')
                          Text(
                            " (Đã chuyển dời tiền!)",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      donate_details.project_name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('kk:mm dd-MM-yy').format(DateTime.parse(donate_details.donate_date)),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Container(
                height: 90,
                width: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.projects.where((p) => p.prj_id==donate_details.project_id).elementAt(0).image_url),
                    )),
              ),
            ],
          )
        )
    );
  }
}

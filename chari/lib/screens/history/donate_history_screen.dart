import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:quiver/async.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:chari/services/services.dart';

class HistoryScreen extends StatefulWidget {
  List<DonateDetails> donate_details_list;
  List<Project> projects;
  final Donator donator;
  int total;
  HistoryScreen({Key key, @required this.donate_details_list,this.projects,this.donator,this.total}) : super(key: key);
  @override
  _HistoryScreenState createState()=> _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>{

  int step = 5;
  int numViewItem;
  var inpage_donate_details_list;

  @override
  void initState() {
    super.initState();
    inpage_donate_details_list=widget.donate_details_list;
    if(widget.total>=step){
      numViewItem=step;
    }else{
      numViewItem = widget.total;
    }
  }

  _getMoreDonateHistory(){
    DonateDetailsService.getDonateDetailsListByDonatorIdFromAToB(widget.donator.id,numViewItem,numViewItem+step,widget.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_donate_details_list += list.map((model) => DonateDetails.fromJson(model)).toList();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.white,
        centerTitle: false,
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
              print(widget.total);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(inpage_donate_details_list.isNotEmpty)
              for(int i=0;i<numViewItem;i++)
                buildProjectInfo(inpage_donate_details_list[i]),

            if(numViewItem != widget.total )
              Center(
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  onPressed: ()=>{
                    _getMoreDonateHistory(),
                    setState(() {
                      if(numViewItem<=widget.total-step){
                        numViewItem+=step;
                      }else{
                        numViewItem+= widget.total - numViewItem;
                      }
                    })
                  },
                  child: Text(
                    'Xem thêm',
                    style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
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
